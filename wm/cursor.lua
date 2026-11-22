local ffi = require("cffi")
local wau = require("wau")

-- Cursor manager: loads XCursor themes via wau and sets cursor images on
-- wl_pointer when the seat has no client focus (e.g. during move/resize ops).
-- Also calls river_seat_v1.set_xcursor_theme so the compositor renders the
-- right theme for clients.

local Cursor = { mt = {} }
Cursor.mt.__index = Cursor

-- Map operation/edge combinations to standard cursor names
Cursor.states = {
    idle = "default",
    move = "move",
}

local resize_cursor = {
    { top = true, left = true, name = "nw-resize" },
    { top = true, right = true, name = "ne-resize" },
    { bottom = true, left = true, name = "sw-resize" },
    { bottom = true, right = true, name = "se-resize" },
    { top = true, name = "n-resize" },
    { bottom = true, name = "s-resize" },
    { left = true, name = "w-resize" },
    { right = true, name = "e-resize" },
}

function Cursor.create(config)
    config = config or {}
    return setmetatable({
        theme_name = config.theme,
        size = config.size or 24,
        theme = nil,
        compositor = nil,
        shm = nil,
        surface = nil,
        pointer = nil,
        seat_name = nil,
        initialized = false,
        current_image = nil,
        current_hotspot_x = 0,
        current_hotspot_y = 0,
    }, Cursor.mt)
end

function Cursor:bind_globals(display, registry)
    self.display = display
    self.compositor = wau.wl_compositor
    self.shm = wau.wl_shm
    if not self.compositor then
        io.stderr:write("wm: cursor: wl_compositor not bound\n")
        return false
    end
    if not self.shm then
        io.stderr:write("wm: cursor: wl_shm not bound\n")
        return false
    end
    return true
end

function Cursor:load_theme()
    if not self.shm then
        return false
    end

    io.stderr:write(string.format("wm: cursor: loading theme '%s' size %d\n",
        self.theme_name or "default", self.size))

    local ok, theme = pcall(wau.wl_cursor_theme.load,
        self.theme_name, self.size, self.shm)
    if not ok or theme == nil then
        if self.theme_name then
            io.stderr:write(("wm: cursor theme '%s' not found, trying default\n")
                :format(self.theme_name))
            ok, theme = pcall(wau.wl_cursor_theme.load, nil, self.size, self.shm)
        end
        if not ok or theme == nil then
            io.stderr:write("wm: failed to load cursor theme\n")
            return false
        end
    end

    self.theme = theme
    io.stderr:write("wm: cursor: theme loaded successfully\n")
    return true
end

function Cursor:create_surface()
    if not self.compositor then
        return false
    end
    self.surface = self.compositor:create_surface()
    if self.surface == nil then
        io.stderr:write("wm: cursor: failed to create surface\n")
        return false
    end
    io.stderr:write("wm: cursor: surface created\n")
    self.initialized = true
    return true
end

function Cursor:attach_pointer(wl_seat_name, registry)
    if self.pointer ~= nil then
        return true
    end

    io.stderr:write(string.format("wm: cursor: binding wl_seat global name %d\n", wl_seat_name))

    local wl_seat = nil
    registry:add_listener {
        ["global"] = function (self, name, iface, version)
            if name == wl_seat_name and iface == "wl_seat" and wl_seat == nil then
                wl_seat = self:bind(name, wau.wl_seat, math.min(version, 8))
            end
        end,
    }
    self.display:roundtrip()

    if wl_seat == nil then
        io.stderr:write("wm: failed to bind wl_seat for cursor\n")
        return false
    end

    self.wl_seat = wl_seat
    self.pointer = wl_seat:get_pointer()
    if self.pointer == nil then
        io.stderr:write("wm: failed to get wl_pointer\n")
        return false
    end

    io.stderr:write("wm: cursor: pointer attached successfully\n")
    return true
end

function Cursor:apply_xcursor_theme(seat)
    if self.theme_name and seat and seat.set_xcursor_theme then
        seat.obj:set_xcursor_theme(self.theme_name or "default", self.size)
    end
end

function Cursor:get_image(name)
    if self.theme == nil then
        return nil
    end
    local cursor = self.theme:get_cursor(name)
    if cursor == nil then
        return nil
    end
    return cursor.image[1], cursor.name
end

function Cursor:resolve_name(name)
    local aliases = {
        ["default"] = { "default", "left_ptr" },
        ["move"] = { "move", "fleur", "all-scroll" },
        ["n-resize"] = { "n-resize", "top_side" },
        ["s-resize"] = { "s-resize", "bottom_side" },
        ["e-resize"] = { "e-resize", "right_side" },
        ["w-resize"] = { "w-resize", "left_side" },
        ["nw-resize"] = { "nw-resize", "top_left_corner" },
        ["ne-resize"] = { "ne-resize", "top_right_corner" },
        ["sw-resize"] = { "sw-resize", "bottom_left_corner" },
        ["se-resize"] = { "se-resize", "bottom_right_corner" },
        ["text"] = { "text", "xterm" },
        ["pointer"] = { "pointer", "hand2", "hand1" },
    }
    local list = aliases[name] or { name }
    for _, candidate in ipairs(list) do
        if self.theme and self.theme:get_cursor(candidate) ~= nil then
            return candidate
        end
    end
    return nil
end

function Cursor:set(river_seat, name)
    if not self.initialized or self.pointer == nil or self.surface == nil then
        io.stderr:write(string.format("wm: cursor: set called but not ready (initialized=%s, pointer=%s, surface=%s)\n",
            tostring(self.initialized), tostring(self.pointer ~= nil), tostring(self.surface ~= nil)))
        return
    end

    io.stderr:write(string.format("wm: cursor: setting cursor '%s'\n", name))

    local resolved = self:resolve_name(name)
    if resolved == nil then
        io.stderr:write(string.format("wm: cursor: could not resolve cursor name '%s'\n", name))
        return
    end

    local cursor = self.theme:get_cursor(resolved)
    if cursor == nil then
        io.stderr:write(string.format("wm: cursor: could not get cursor '%s'\n", resolved))
        return
    end
    local image = cursor.image[1]
    if image == nil then
        io.stderr:write(string.format("wm: cursor: no images in cursor '%s'\n", resolved))
        return
    end

    -- Avoid redundant set_cursor calls
    if image == self.current_image then
        return
    end

    local buffer = image:get_buffer()
    self.surface:attach(buffer, 0, 0)
    self.surface:commit()
    self.pointer:set_cursor(0, self.surface, image.hotspot_x, image.hotspot_y)

    self.current_image = image
    self.current_hotspot_x = image.hotspot_x
    self.current_hotspot_y = image.hotspot_y
    io.stderr:write(string.format("wm: cursor: set '%s' successfully\n", name))
end

function Cursor:set_idle(river_seat)
    self:set(river_seat, "default")
end

function Cursor:set_move(river_seat)
    self:set(river_seat, "move")
end

function Cursor:set_resize(river_seat, edges)
    for _, entry in ipairs(resize_cursor) do
        local match = true
        for edge, value in pairs(entry) do
            if edge ~= "name" and edges[edge] ~= value then
                match = false
                break
            end
        end
        if match then
            self:set(river_seat, entry.name)
            return
        end
    end
    self:set(river_seat, "default")
end

function Cursor:destroy()
    if self.pointer ~= nil then
        self.pointer:release()
        self.pointer = nil
    end
    if self.wl_seat ~= nil then
        self.wl_seat:release()
        self.wl_seat = nil
    end
    if self.theme ~= nil then
        self.theme:destroy()
        self.theme = nil
    end
    self.initialized = false
end

return Cursor
