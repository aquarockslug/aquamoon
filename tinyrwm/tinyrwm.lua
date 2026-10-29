#! /usr/bin/env lua
-- SPDX-FileCopyrightText: © 2026 FireFly
-- SPDX-License-Identifier: 0BSD

local wau = require("wau")
local xkbcommon = require("tinyrwm.xkbcommon")
local posix = require("posix")

wau:require("tinyrwm.protocol.river-window-management-v1")
wau:require("tinyrwm.protocol.river-xkb-bindings-v1")
wau:require("tinyrwm.protocol.river-layer-shell-v1")

local globals = {}
local required_globals = {
    ["river_window_manager_v1"] = 4,
    ["river_xkb_bindings_v1"] = 1,
}
local optional_globals = {
    ["river_layer_shell_v1"] = 1,
}

local Mods = wau.river_seat_v1.Modifiers

---- Configuration -------------------
-- The aquamoon TOML file is the source of truth for bindings, startup
-- commands, borders and rules.  It is optional: without it tinyrwm falls back
-- to the upstream tiny feature set.
local repo = os.getenv("AQUAMOON_DIR") or ((os.getenv("HOME") or "") .. "/.aquamoon")
local config_path = os.getenv("AQUAMOON_CONFIG") or (repo .. "/toml/aquamoon.toml")

local function warn(message)
    io.stderr:write("tinyrwm: " .. message .. "\n")
end

local config = {}
do
    local file = io.open(config_path, "r")
    if file then
        file:close()
        package.path = repo .. "/lua/?.lua;" .. package.path
        local ok, tinytoml = pcall(require, "tinytoml")
        if ok then
            local parsed, value = pcall(tinytoml.parse, config_path)
            if parsed and type(value) == "table" then
                config = value
            else
                warn("unable to parse " .. config_path .. ": " .. tostring(value))
            end
        else
            warn("unable to load tinytoml: " .. tostring(tinytoml))
        end
    end
end

local function number(value)
    return math.tointeger(tonumber(value)) or 0
end

local MODIFIERS = {
    none = 0,
    shift = Mods.SHIFT,
    ctrl = Mods.CTRL,
    control = Mods.CTRL,
    alt = Mods.MOD1,
    mod1 = Mods.MOD1,
    mod3 = Mods.MOD3,
    super = Mods.MOD4,
    logo = Mods.MOD4,
    mod4 = Mods.MOD4,
    mod5 = Mods.MOD5,
}

local function modifiers(value)
    if value == nil then
        return 0
    end
    if type(value) == "table" then
        value = table.concat(value, "+")
    end

    local result = 0
    for part in tostring(value):gmatch("[^+]+") do
        local modifier = MODIFIERS[part:lower()]
        if modifier == nil then
            warn("unknown modifier: " .. part)
        else
            result = result | modifier
        end
    end
    return result
end

local function command(value)
    if type(value) == "table" then
        local result = {}
        for i, part in ipairs(value) do
            result[i] = tostring(part)
        end
        return result
    end
    return { tostring(value) }
end

local BUTTONS = {
    BTN_LEFT = 0x110,
    BTN_RIGHT = 0x111,
    BTN_MIDDLE = 0x112,
}

local xkb_bindings = {}
local pointer_bindings = {}
do
    local maps = config.map or {}
    for _, binding in ipairs((maps.normal or {}).bindings or {}) do
        if binding.key == nil or xkbcommon.keysym(binding.key) == 0 then
            warn("unknown keysym: " .. tostring(binding.key))
        else
            xkb_bindings[#xkb_bindings + 1] = {
                key = binding.key,
                mods = modifiers(binding.mod),
                command = command(binding.command),
                on_release = binding.opt == "release",
            }
        end
    end

    local pointer_maps = config["map-pointer"] or {}
    for _, binding in ipairs((pointer_maps.normal or {}).bindings or {}) do
        local button = BUTTONS[binding.key]
        if button == nil then
            warn("unknown mouse button: " .. tostring(binding.key))
        else
            pointer_bindings[#pointer_bindings + 1] = {
                button = button,
                mods = modifiers(binding.mod),
                command = command(binding.command),
            }
        end
    end
end

if #xkb_bindings == 0 then
    xkb_bindings = {
        { key = "space", mods = Mods.MOD4, command = { "spawn", "foot" } },
        { key = "q", mods = Mods.MOD4, command = { "close" } },
        { key = "n", mods = Mods.MOD4, command = { "focus-next" } },
        { key = "Escape", mods = Mods.MOD4, command = { "exit" } },
    }
end

if #pointer_bindings == 0 then
    pointer_bindings = {
        { button = BUTTONS.BTN_LEFT, mods = Mods.MOD4, command = { "move-view" } },
        { button = BUTTONS.BTN_RIGHT, mods = Mods.MOD4, command = { "resize-view" } },
    }
end

local river_options = config.river_options or {}
local border_width = number(river_options["border-width"])

local function color(value)
    local hex = tostring(value or "0xffffff"):gsub("^0[xX]", "")
    local rgb = math.tointeger(tonumber(hex, 16)) or 0xffffff
    local function component(value)
        return math.floor(value * 0xffffffff / 0xff)
    end
    return {
        component((rgb >> 16) & 0xff),
        component((rgb >> 8) & 0xff),
        component(rgb & 0xff),
        0xffffffff,
    }
end

local border_focused = color(river_options["border-color-focused"])
local border_unfocused = color(river_options["border-color-unfocused"])

local focus_follows_cursor = river_options["focus-follows-cursor"]
focus_follows_cursor = focus_follows_cursor ~= nil and focus_follows_cursor ~= "disabled"

local attach_bottom = river_options["default-attach-mode"] == "bottom"

local ssd_apps = {}
for _, app_id in pairs((config.window_rules or {}).ssd or {}) do
    ssd_apps[tostring(app_id)] = true
end

local function spawn(shell_command)
    if posix.unistd.fork() == 0 then
        posix.unistd.execp("/bin/sh", { "-c", shell_command })
        os.exit(127)
    end
end

local function shell_command(value)
    local args = type(value) == "table" and value or { value }
    if #args == 1 then
        local arg = tostring(args[1])
        if arg:sub(1, 1) == '"' and arg:sub(-1) == '"' then
            return arg:sub(2, -2)
        end
        return arg
    end

    local result = {}
    for i, part in ipairs(args) do
        result[i] = tostring(part)
    end
    return table.concat(result, " ")
end

local function start()
    local startup = {}
    for key, value in pairs(config.startup or {}) do
        startup[#startup + 1] = { tonumber(key) or math.huge, value }
    end
    table.sort(startup, function (a, b) return a[1] < b[1] end)
    for _, entry in ipairs(startup) do
        spawn(shell_command(entry[2]))
    end
end

local wm = {
    outputs = {},
    seats = {},
    -- Windows are kept in rendering order; last window is topmost.
    windows = {},
    -- Tags currently visible on the output.
    view_tags = 1,
    -- Output used for layer surfaces that do not request one explicitly.
    default_output = nil,
}

local function table_index_of(tbl, sought)
    for i, v in ipairs(tbl) do
        if v == sought then return i end
    end
    return 0
end

local function table_filter_inplace(tbl, pred)
    local removed = 0
    for i=1,#tbl do
        if pred(tbl[i]) then
            tbl[i - removed] = tbl[i]
        else
            removed = removed + 1
        end
        if removed > 0 then tbl[i] = nil end
    end
    return tbl
end


---- Output ---------------------------
local Output = { mt = {}, listener = {} }
Output.mt.__index = Output

function Output.create(obj)
    local output = { obj = obj }
    setmetatable(output, Output.mt)
    obj:set_user_data(output)
    obj:add_listener(Output.listener)

    local shell = globals["river_layer_shell_v1"]
    if shell ~= nil then
        output.layer_shell = shell:get_output(obj)
        output.layer_shell:add_listener {
            ["non_exclusive_area"] = function (_, x, y, width, height)
                output.non_exclusive_area = {
                    x = x,
                    y = y,
                    width = width,
                    height = height,
                }
            end,
        }
    end

    return output
end

function Output:maybe_destroy()
    if self.removed then
        if self.layer_shell ~= nil then
            self.layer_shell:destroy()
        end
        self.obj:destroy()
    else
        return self
    end
end

function Output.listener:removed()
    self:get_user_data().removed = true
end


---- Window ---------------------------
local Window = { mt = {}, listener = {} }
Window.mt.__index = Window

function Window.create(obj)
    local window = {
        obj = obj,
        node = obj:get_node(),
        new = true,
        visible = false,
        tags = wm.view_tags,
    }
    setmetatable(window, Window.mt)
    obj:set_user_data(window)
    obj:add_listener(Window.listener)
    return window
end

function Window:maybe_destroy()
    if self.closed then
        self.obj:destroy()
        self.node:destroy()
    else
        return self
    end
end

function Window:set_borders(focused)
    if border_width == 0 then
        return
    end
    local rgba = focused and border_focused or border_unfocused
    self.obj:set_borders(
        1 | 2 | 4 | 8, border_width,
        rgba[1], rgba[2], rgba[3], rgba[4]
    )
end

function Window:update_visibility()
    local visible = (self.tags & wm.view_tags) ~= 0
    if visible ~= self.visible then
        self.visible = visible
        if visible then
            self.obj:show()
        else
            self.obj:hide()
        end
    end
end

function Window:manage()
    if self.new then
        self.new = nil
        if self.ssd then
            self.obj:use_ssd()
        end
        self:set_position(0, 0)
        self.obj:propose_dimensions(0, 0)
        self:update_visibility()
        self:set_borders(false)
    end

    local move = self.pointer_move_requested
    if move ~= nil then
        self.pointer_move_requested = nil
        move.seat:pointer_move(self)
    end

    local resize = self.pointer_resize_requested
    if resize ~= nil then
        self.pointer_resize_requested = nil
        resize.seat:pointer_resize(self, resize.edges)
    end
end

function Window:set_position(x, y)
    self.node:set_position(x, y)
    self.x = x
    self.y = y
end

function Window.listener:closed()
    self:get_user_data().closed = true
end
function Window.listener:dimensions(width, height)
    local window = self:get_user_data()
    window.width = width
    window.height = height
end
function Window.listener:app_id(app_id)
    local window = self:get_user_data()
    window.app_id = app_id
    if app_id ~= nil and ssd_apps[app_id] then
        window.ssd = true
    end
end
function Window.listener:pointer_move_requested(seat)
    self:get_user_data().pointer_move_requested = {
        seat = seat:get_user_data(),
    }
end
function Window.listener:pointer_resize_requested(seat, edges)
    local Edges = wau.river_window_v1.Edges
    self:get_user_data().pointer_resize_requested = {
        seat = seat:get_user_data(),
        edges = {
            left = (edges & Edges.LEFT) ~= 0,
            right = (edges & Edges.RIGHT) ~= 0,
            top = (edges & Edges.TOP) ~= 0,
            bottom = (edges & Edges.BOTTOM) ~= 0,
        },
    }
end


---- Tags -----------------------------
function wm.topmost_visible()
    for i = #wm.windows, 1, -1 do
        if wm.windows[i].visible then
            return wm.windows[i]
        end
    end
end

function wm.refresh()
    for _, window in ipairs(wm.windows) do
        window:update_visibility()
    end

    for _, seat in ipairs(wm.seats) do
        if seat.focused and not seat.focused.visible then
            seat.focused = nil
        end
        if seat.focused == nil and seat.layer_focus == nil then
            seat:focus(nil)
        end
    end
end


---- Seat -----------------------------
local Seat = { mt = {}, listener = {} }
Seat.mt.__index = Seat

function Seat.create(obj)
    local seat = {
        obj = obj,
        new = true,
        xkb_bindings = {},
        pointer_bindings = {},
    }
    setmetatable(seat, Seat.mt)
    obj:set_user_data(seat)
    obj:add_listener(Seat.listener)

    local shell = globals["river_layer_shell_v1"]
    if shell ~= nil then
        seat.layer_shell = shell:get_seat(obj)
        seat.layer_shell:add_listener {
            ["focus_exclusive"] = function (_)
                seat.layer_focus = "exclusive"
            end,
            ["focus_non_exclusive"] = function (_)
                seat.layer_focus = "non_exclusive"
            end,
            ["focus_none"] = function (_)
                seat.layer_focus = nil
                -- The compositor cleared keyboard focus when the layer
                -- surface went away; send it back to the window.
                seat.refocus = true
            end,
        }
    end

    return seat
end

function Seat:focus(window)
    if window == nil then
        -- Fall back to topmost visible window.
        window = wm.topmost_visible()
    end

    if window ~= nil and (not window.visible or window.closed) then
        window = nil
    end

    if window then
        if self.focused ~= window then
            if self.focused ~= nil then
                self.focused:set_borders(false)
            end
            self.obj:focus_window(window.obj)
            self.focused = window
            -- Move to top
            local i = table_index_of(wm.windows, window)
            table.remove(wm.windows, i)
            table.insert(wm.windows, window)
            window.node:place_top()
            window:set_borders(true)
        end
    else
        if self.focused ~= nil then
            self.focused:set_borders(false)
        end
        self.obj:clear_focus()
        self.focused = nil
    end
end

function Seat:focus_relative(direction)
    local visible = {}
    for _, window in ipairs(wm.windows) do
        if window.visible then
            visible[#visible + 1] = window
        end
    end
    if #visible == 0 then
        return
    end

    local index = table_index_of(visible, self.focused)
    local target
    if direction == "previous" then
        target = visible[index > 1 and index - 1 or #visible]
    else
        target = visible[index > 0 and index < #visible and index + 1 or 1]
    end
    self:focus(target)
end

function Seat:toggle_fullscreen(window)
    if window == nil then
        return
    end

    if window.fullscreen then
        window.obj:exit_fullscreen()
        window.fullscreen = false
        local geometry = window.saved_geometry
        if geometry ~= nil and geometry.width ~= nil and geometry.height ~= nil then
            window:set_position(geometry.x, geometry.y)
            window.obj:propose_dimensions(geometry.width, geometry.height)
        end
    else
        local output = wm.outputs[1]
        if output == nil then
            return
        end
        window.saved_geometry = {
            x = window.x,
            y = window.y,
            width = window.width,
            height = window.height,
        }
        window.obj:fullscreen(output.obj)
        window.fullscreen = true
    end
end

function Seat:pointer_move(window)
    if self.op == nil then
        self:focus(window)
        self.obj:op_start_pointer()
        self.op = {
            type = "move",
            window = window,
            start = { x = window.x, y = window.y },
            dx = 0,
            dy = 0,
        }
    end
end

function Seat:pointer_resize(window, edges)
    if self.op == nil then
        self:focus(window)
        window.obj:inform_resize_start()
        self.obj:op_start_pointer()
        self.op = {
            type = "resize",
            window = window,
            edges = edges,
            start = {
                x = window.x,
                y = window.y,
                width = window.width,
                height = window.height,
            },
            dx = 0,
            dy = 0,
        }
    end
end

function Seat:action(command)
    local action = command[1]

    if action == "spawn" then
        local args = {}
        for i = 2, #command do
            args[#args + 1] = command[i]
        end
        local shell = shell_command(args)
        if shell ~= "" then
            spawn(shell)
        end
    elseif action == "close" then
        if self.focused ~= nil then
            self.focused.obj:close()
        end
    elseif action == "focus-next" then
        self:focus_relative("next")
    elseif action == "focus-view" then
        self:focus_relative(command[2] or "next")
    elseif action == "set-focused-tags" then
        local tags = number(command[2])
        if tags ~= 0 then
            wm.view_tags = tags
            wm.refresh()
        end
    elseif action == "set-view-tags" then
        local tags = number(command[2])
        if tags ~= 0 and self.focused ~= nil then
            self.focused.tags = tags
            wm.refresh()
        end
    elseif action == "toggle-focused-tags" then
        local tags = number(command[2])
        if (wm.view_tags ~ tags) ~= 0 then
            wm.view_tags = wm.view_tags ~ tags
            wm.refresh()
        end
    elseif action == "toggle-view-tags" then
        local tags = number(command[2])
        if self.focused ~= nil and (self.focused.tags ~ tags) ~= 0 then
            self.focused.tags = self.focused.tags ~ tags
            wm.refresh()
        end
    elseif action == "toggle-fullscreen" then
        self:toggle_fullscreen(self.focused)
    elseif action == "move-view" or action == "move" then
        if self.hovered ~= nil then
            self:pointer_move(self.hovered)
        end
    elseif action == "resize-view" or action == "resize" then
        if self.hovered ~= nil then
            self:pointer_resize(self.hovered, { bottom = true, right = true })
        end
    elseif action == "exit" then
        globals["river_window_manager_v1"]:exit_session()
    else
        print("Seat:action: unimplemented", action)
    end
end

function Seat:add_pointer_binding(button, mods, command)
    local obj = self.obj:get_pointer_binding(button, mods)
    local binding = { obj = obj }

    obj:add_listener {
        ["pressed"] = function (_)
            self.pending_action = command
        end,
    }
    obj:enable()
    table.insert(self.pointer_bindings, binding)
end

function Seat:add_xkb_binding(key, mods, command, on_release)
    local keysym = xkbcommon.keysym(key)
    local obj = globals["river_xkb_bindings_v1"]:get_xkb_binding(
                    self.obj, keysym, mods)
    local binding = { obj = obj }

    obj:add_listener {
        ["pressed"] = function (_)
            if not on_release then
                self.pending_action = command
            end
        end,
        ["released"] = function (_)
            if on_release then
                self.pending_action = command
            end
        end,
    }
    obj:enable()
    table.insert(self.xkb_bindings, binding)
end

function Seat:manage()
    if self.new then
        self.new = nil

        for _, binding in ipairs(xkb_bindings) do
            self:add_xkb_binding(
                binding.key, binding.mods, binding.command, binding.on_release)
        end

        for _, binding in ipairs(pointer_bindings) do
            self:add_pointer_binding(
                binding.button, binding.mods, binding.command)
        end
    end

    if self.focused and (self.focused.closed or not self.focused.visible) then
        self.focused = nil
    end

    if self.layer_focus == nil then
        if self.refocus then
            self.refocus = nil
            if self.focused ~= nil then
                self.obj:focus_window(self.focused.obj)
                self.focused:set_borders(true)
            else
                self:focus(self.interacted)
            end
        else
            self:focus(self.interacted)
        end

        if self.focus_follow ~= nil then
            self:focus(self.focus_follow)
        end
    elseif self.focused ~= nil then
        -- A layer surface owns keyboard focus; don't fight it.
        self.focused:set_borders(false)
    end

    self.interacted = nil
    self.focus_follow = nil

    if self.pending_action ~= nil then
        self:action(self.pending_action)
        self.pending_action = nil
    end

    if self.op and self.op.window then
        local op, window = self.op, self.op.window

        if window.closed then
            self.obj:op_end()
            self.op = nil

        elseif self.op_release then
            if op.type == "resize" then
                window.obj:inform_resize_end()
            end
            self.obj:op_end()
            self.op = nil

        elseif op.type == "resize" then
            local width = math.max(
                1,
                op.edges.left and (op.start.width - op.dx) or
                op.edges.right and (op.start.width + op.dx) or
                op.start.width
            )
            local height = math.max(
                1,
                op.edges.top and (op.start.height - op.dy) or
                op.edges.bottom and (op.start.height + op.dy) or
                op.start.height
            )
            window.obj:propose_dimensions(width, height)
        end
    end

    self.op_release = nil
end

function Seat:render()
    if self.op and self.op.window then
        local op, window = self.op, self.op.window
        if self.op.type == "move" then
            window:set_position(
                op.start.x + op.dx,
                op.start.y + op.dy
            )
        elseif self.op.type == "resize" then
            local x = op.edges.left
                      and (op.start.x + (op.start.width - window.width))
                      or op.start.x
            local y = op.edges.top
                      and (op.start.y + (op.start.height - window.height))
                      or op.start.y
            window:set_position(x, y)
        end
    end
end

function Seat:maybe_destroy()
    if self.removed then
        for _, binding in ipairs(self.xkb_bindings) do
            binding.obj:destroy()
        end
        for _, binding in ipairs(self.pointer_bindings) do
            binding.obj:destroy()
        end
        if self.layer_shell ~= nil then
            self.layer_shell:destroy()
        end
        self.obj:destroy()
    else
        return self
    end
end

function Seat.listener.removed(self)
    self:get_user_data().removed = true
end
function Seat.listener.pointer_enter(self, window)
    local seat = self:get_user_data()
    seat.hovered = window:get_user_data()
    if focus_follows_cursor and seat.hovered.visible then
        seat.focus_follow = seat.hovered
        globals["river_window_manager_v1"]:manage_dirty()
    end
end
function Seat.listener.pointer_leave(self)
    self:get_user_data().hovered = nil
end
function Seat.listener.window_interaction(self, window)
    self:get_user_data().interacted = window:get_user_data()
end
function Seat.listener.op_delta(self, dx, dy)
    local seat = self:get_user_data()
    seat.op.dx = dx
    seat.op.dy = dy
end
function Seat.listener.op_release(self)
    self:get_user_data().op_release = true
end


---- wm -------------------------------
local function wm_manage()
    table_filter_inplace(wm.outputs, Output.maybe_destroy)
    table_filter_inplace(wm.windows, Window.maybe_destroy)
    table_filter_inplace(wm.seats, Seat.maybe_destroy)

    if wm.default_output ~= nil and wm.default_output.removed then
        wm.default_output = nil
    end
    if wm.default_output == nil then
        local output = wm.outputs[1]
        if output ~= nil and output.layer_shell ~= nil then
            output.layer_shell:set_default()
            wm.default_output = output
        end
    end

    for _, window in ipairs(wm.windows) do
        window:manage()
    end

    for _, seat in ipairs(wm.seats) do
        seat:manage()
    end

    globals["river_window_manager_v1"]:manage_finish()
end

local function wm_render()
    for _, seat in ipairs(wm.seats) do
        seat:render()
    end

    globals["river_window_manager_v1"]:render_finish()
end

local wm_handlers = {
    ["unavailable"] = function (self)
        io.stderr:write("another window manager is already running\n")
        os.exit(1)
    end,
    ["finished"] = function (self)
        os.exit(0)
    end,
    ["manage_start"] = wm_manage,
    ["render_start"] = wm_render,
    ["output"] = function (self, obj)
        table.insert(wm.outputs, Output.create(obj))
    end,
    ["seat"] = function (self, obj)
        table.insert(wm.seats, Seat.create(obj))
    end,
    ["window"] = function (self, obj)
        local window = Window.create(obj)
        if attach_bottom then
            table.insert(wm.windows, 1, window)
        else
            table.insert(wm.windows, window)
        end
    end,
}


---- Entry point ----------------------
display = wau.wl_display.connect()
assert(display, "Failed to connect to wayland compositor")

-- Ensure we exit nonzero if an event handler errors
local function handle_callback_error(proxy, name, func, err)
    io.stderr:write(("-- Error calling event handler for %s %q:")
                        :format(tostring(proxy), name))
    io.stderr:write(("%s\n"):format(tostring(err)))
    os.exit(1)
end
wau.wl_proxy.set_error_callback(handle_callback_error)

-- Avoid passing WAYLAND_DEBUG to our children
posix.stdlib.setenv("WAYLAND_DEBUG", nil)

-- Ensure children are automatically reaped
posix.signal.signal(posix.signal.SIGCHLD, posix.signal.SIG_IGN)

local registry = display:get_registry()
registry:add_listener {
    ["global"] = function (self, name, iface, version)
        local required_version = required_globals[iface]
        local optional_version = optional_globals[iface]
        if required_version ~= nil then
            assert(required_version <= version,
                ("wayland compositor supported %s version too old (need %d, got %d)")
                    :format(iface, required_version, version))
            globals[iface] = self:bind(name, wau[iface], required_version)
        elseif optional_version ~= nil then
            globals[iface] = self:bind(name, wau[iface],
                math.min(optional_version, version))
        end
    end,
}

display:roundtrip()

for k in pairs(required_globals) do
    assert(globals[k] ~= nil, ("wayland compositor does not support %s"):format(k))
end

globals["river_window_manager_v1"]:add_listener(wm_handlers)

start()

while display:dispatch() do end
