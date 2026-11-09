#! /usr/bin/env lua5.4
-- SPDX-FileCopyrightText: © 2026 FireFly
-- SPDX-License-Identifier: 0BSD

local ffi = require("cffi")
local wau = require("wau")
local xkbcommon = require("wm.xkbcommon")
local raw = require("wau.core.raw")

ffi.cdef [[
    typedef long time_t;
    typedef int pid_t;
    typedef unsigned long nfds_t;
    typedef void (*sighandler_t)(int);

    struct timespec {
        time_t tv_sec;
        long tv_nsec;
    };

    struct pollfd {
        int fd;
        short events;
        short revents;
    };

    int clock_gettime(int clk_id, struct timespec *tp);
    pid_t fork(void);
    int execl(const char *pathname, const char *arg, ...);
    void _exit(int status);
    int unsetenv(const char *name);
    sighandler_t signal(int signum, sighandler_t handler);
    int poll(struct pollfd *fds, nfds_t nfds, int timeout);
    int *__errno_location(void);
    char *strerror(int errnum);
]]

local CLOCK_MONOTONIC = 1
local EINTR = 4
local SIGCHLD = 17
local SIG_IGN = ffi.cast("sighandler_t", 1)
local POLLIN = 0x0001
local POLLERR = 0x0008
local POLLHUP = 0x0010

wau:require("wm.protocol.river-window-management-v1")
wau:require("wm.protocol.river-xkb-bindings-v1")
wau:require("wm.protocol.river-layer-shell-v1")
wau:require("wm.protocol.river-input-management-v1")
wau:require("wm.protocol.river-libinput-config-v1")

local globals = {}
local required_globals = {
    ["river_window_manager_v1"] = 4,
    ["river_xkb_bindings_v1"] = 2,
}
local optional_globals = {
    ["river_layer_shell_v1"] = 1,
    ["river_input_manager_v1"] = 2,
    ["river_libinput_config_v1"] = 2,
}

local Mods = wau.river_seat_v1.Modifiers

---- Configuration -------------------
-- The aquamoon TOML file is the source of truth for bindings, startup
-- commands, borders and rules.  It is optional: without it wm falls back
-- to the upstream tiny feature set.
local repo = os.getenv("AQUAMOON_DIR") or ((os.getenv("HOME") or "") .. "/.aquamoon")
local config_path = os.getenv("AQUAMOON_CONFIG") or (repo .. "/toml/aquamoon.toml")

local function warn(message)
    io.stderr:write("wm: " .. message .. "\n")
end

local config = {}
do
    local file = io.open(config_path, "r")
    if file then
        file:close()
        package.path = repo .. "/lua/?.lua;" .. package.path
        local ok, toml = pcall(require, "neovim.toml")
        if ok then
            local parsed, value = pcall(toml.parse, config_path)
            if parsed and type(value) == "table" then
                config = value
            else
                warn("unable to parse " .. config_path .. ": " .. tostring(value))
            end
        else
            warn("unable to load neovim.toml parser: " .. tostring(toml))
        end
    end
end

local function number(value)
    return math.tointeger(tonumber(value)) or 0
end

local monotonic_ts = ffi.new("struct timespec")
local function monotonic_ms()
    ffi.C.clock_gettime(CLOCK_MONOTONIC, monotonic_ts)
    return tonumber(monotonic_ts.tv_sec) * 1000 + tonumber(monotonic_ts.tv_nsec) / 1000000
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
                is_repeat = binding.opt == "repeat",
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
        { key = "t", mods = Mods.MOD4, command = { "toggle-tiling" } },
        { key = "space", mods = Mods.MOD4 | Mods.SHIFT,
          command = { "toggle-floating" } },
        { key = "equal", mods = Mods.MOD4,
          command = { "increase-main-ratio" } },
        { key = "minus", mods = Mods.MOD4,
          command = { "decrease-main-ratio" } },
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

-- Keyboard repeat defaults match riverctl's historical defaults.  The value
-- in the TOML file is { rate, delay } in repeats per second and milliseconds.
local repeat_rate, repeat_delay = 25, 600
do
    local value = river_options["set-repeat"]
    if type(value) == "table" and value[1] ~= nil and value[2] ~= nil then
        repeat_rate = number(value[1])
        repeat_delay = number(value[2])
    elseif type(value) == "string" then
        local rate, delay = value:match("^(%d+)%s+(%d+)$")
        if rate ~= nil then
            repeat_rate = number(rate)
            repeat_delay = number(delay)
        end
    end
    if repeat_rate < 0 or repeat_delay < 0 then
        warn("invalid set-repeat; using 25 600")
        repeat_rate, repeat_delay = 25, 600
    end
end

local input_rules = {}
do
    for _, input in pairs(config.inputs or {}) do
        if type(input) == "table" and input.device ~= nil then
            input_rules[#input_rules + 1] = input
        end
    end
    table.sort(input_rules, function (a, b)
        return tostring(a.device) < tostring(b.device)
    end)
end

-- river 0.5 reports the libinput name ("PIXA200B:00 093A:200B Touchpad")
-- while river-classic used "pointer-vendor-product-name" identifiers.  Accept
-- both forms so the existing configuration keeps working.
local function normalize_device(name)
    local value = tostring(name or ""):lower()
    value = value:gsub("^[%a_]+%-%d+%-%d+%-", "")
    value = value:gsub("[%s:%-]+", "_")
    value = value:gsub("_+", "_")
    return value
end

local function input_rule_for(name)
    local normalized = normalize_device(name)
    for _, rule in ipairs(input_rules) do
        local device = tostring(rule.device)
        if device == name or normalize_device(device) == normalized then
            return rule
        end
    end
end

local ssd_apps = {}
for _, app_id in pairs((config.window_rules or {}).ssd or {}) do
    ssd_apps[tostring(app_id)] = true
end

local function spawn(shell_command)
    if ffi.C.fork() == 0 then
        ffi.C.execl("/bin/sh", "sh", "-c", shell_command, ffi.nullptr)
        ffi.C._exit(127)
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
    -- Automatically arrange visible windows in the tiling layout.
    tiling = true,
    -- Monotonic insertion order, used to keep the tiled layout stable while
    -- focus (and therefore the stacking order) changes.
    next_window_seq = 0,
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
    local output = {
        obj = obj,
        x = 0,
        y = 0,
        width = 0,
        height = 0,
    }
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

-- Logical area available for windows.  Prefer the area left over by layer
-- surfaces (panels/bars) when the compositor provides it.
function Output:area()
    local area = self.non_exclusive_area
    if area ~= nil and area.width > 0 and area.height > 0 then
        return area
    end
    if self.width > 0 and self.height > 0 then
        return {
            x = self.x,
            y = self.y,
            width = self.width,
            height = self.height,
        }
    end
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
function Output.listener:position(x, y)
    local output = self:get_user_data()
    output.x = x
    output.y = y
end
function Output.listener:dimensions(width, height)
    local output = self:get_user_data()
    output.width = width
    output.height = height
end


---- Window ---------------------------
local Window = { mt = {}, listener = {} }
Window.mt.__index = Window

function Window.create(obj)
    wm.next_window_seq = wm.next_window_seq + 1
    local window = {
        obj = obj,
        node = obj:get_node(),
        new = true,
        visible = false,
        tags = wm.view_tags,
        seq = wm.next_window_seq,
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
        if not wm.tiling then
            self:set_position(0, 0)
            self.obj:propose_dimensions(0, 0)
        end
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

-- Apply a geometry chosen by the tiling layout.  Requests are only sent when
-- something actually changed so a quiet manage cycle does not spam clients.
function Window:set_geometry(x, y, width, height)
    if self.fullscreen then
        return
    end

    if self.x ~= x or self.y ~= y then
        self:set_position(x, y)
    end

    if self.tile_width ~= width or self.tile_height ~= height then
        self.tile_width = width
        self.tile_height = height
        self.obj:propose_dimensions(width, height)
    end
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


---- Layout -----------------------------
-- A deliberately small master/stack layout: the first window takes the left
-- portion of the output and the remaining windows are stacked on the right.
-- Optional tuning lives in the [layout] section of the TOML configuration.
local layout_config = type(config.layout) == "table" and config.layout or {}
local layout_main_ratio = math.max(
    0.1, math.min(0.9, tonumber(layout_config["main-ratio"]) or 2 / 3))
local layout_gaps = math.max(
    0, math.floor(tonumber(layout_config.gaps) or 0))
local layout_smart_gaps = layout_config["smart-gaps"] ~= false
wm.tiling = layout_config.tiled ~= false

local function window_output(window)
    local x = window.x or 0
    local y = window.y or 0
    local width = window.width or 0
    local height = window.height or 0
    local cx = x + width / 2
    local cy = y + height / 2

    for _, output in ipairs(wm.outputs) do
        local area = output:area()
        if area ~= nil and
           cx >= area.x and cx < area.x + area.width and
           cy >= area.y and cy < area.y + area.height then
            return output
        end
    end

    -- Keep the old output if it is still around, otherwise fall back to the
    -- default/first output.  This keeps a window from jumping between outputs
    -- when it is temporarily moved outside every output area.
    if window.output ~= nil and not window.output.removed then
        return window.output
    end
    return wm.default_output or wm.outputs[1]
end

local function tile_output(output, windows)
    local area = output:area()
    if area == nil or #windows == 0 then
        return
    end

    table.sort(windows, function (a, b) return a.seq < b.seq end)

    local gaps = layout_gaps
    if #windows == 1 and layout_smart_gaps then
        gaps = 0
    end

    local available_width = math.max(1, area.width - gaps * 3)
    local available_height = math.max(1, area.height - gaps * 2)

    if #windows == 1 then
        windows[1]:set_geometry(
            area.x + gaps, area.y + gaps,
            math.max(1, area.width - gaps * 2),
            math.max(1, area.height - gaps * 2))
        return
    end

    local main_width = math.max(
        1, math.floor(available_width * layout_main_ratio))
    local side_width = math.max(1, available_width - main_width)
    local main_height = available_height
    local side_height = math.max(
        1, math.floor(
            (available_height - gaps * (#windows - 2)) / (#windows - 1)))

    windows[1]:set_geometry(
        area.x + gaps, area.y + gaps, main_width, main_height)

    local side_x = area.x + main_width + gaps * 2
    for i = 2, #windows do
        windows[i]:set_geometry(
            side_x,
            area.y + gaps + (i - 2) * (side_height + gaps),
            side_width, side_height)
    end
end

function wm.tile()
    if not wm.tiling then
        return
    end

    local by_output = {}
    for _, output in ipairs(wm.outputs) do
        by_output[output] = {}
    end

    for _, window in ipairs(wm.windows) do
        if window.visible and not window.closed and
           not window.floating and not window.fullscreen then
            local output = window_output(window)
            if output ~= nil then
                window.output = output
                local windows = by_output[output]
                if windows == nil then
                    windows = {}
                    by_output[output] = windows
                end
                windows[#windows + 1] = window
            end
        end
    end

    for output, windows in pairs(by_output) do
        if #windows > 0 then
            tile_output(output, windows)
        end
    end
end

-- Force the next manage cycle to send fresh geometry, then schedule it.
local function invalidate_layout()
    for _, window in ipairs(wm.windows) do
        window.tile_width = nil
        window.tile_height = nil
    end
    wm.refresh()
end


---- Input devices --------------------
local input_devices = {}
local libinput_devices = {}
local libinput_by_input_id = {}

local InputDevice = { mt = {}, listener = {} }
InputDevice.mt.__index = InputDevice

function InputDevice.create(obj)
    local device = {
        obj = obj,
        repeat_applied = false,
        libinput_applied = false,
    }
    setmetatable(device, InputDevice.mt)
    obj:set_user_data(device)

    local libinput = libinput_by_input_id[obj:get_id()]
    if libinput ~= nil then
        device.libinput = libinput
        libinput.input = device
    end

    obj:add_listener(InputDevice.listener)
    table.insert(input_devices, device)
    return device
end

function InputDevice:apply()
    if self.done and self.type == 0 and not self.repeat_applied then
        self.repeat_applied = true
        self.obj:set_repeat_info(repeat_rate, repeat_delay)
    end

    if self.libinput_applied or self.libinput == nil or
       not self.libinput.done or self.name == nil then
        return
    end
    self.libinput_applied = true

    local rule = input_rule_for(self.name)
    if rule ~= nil then
        self.libinput:apply(rule)
    end
end

function InputDevice:maybe_destroy()
    if self.removed then
        self.obj:destroy()
    else
        return self
    end
end

function InputDevice.listener:removed()
    self:get_user_data().removed = true
end
function InputDevice.listener:type(kind)
    local device = self:get_user_data()
    device.type = kind
    device:apply()
end
function InputDevice.listener:name(name)
    local device = self:get_user_data()
    device.name = name
    device:apply()
end
function InputDevice.listener:done()
    local device = self:get_user_data()
    device.done = true
    device:apply()
end


local LibinputDevice = { mt = {}, listener = {} }
LibinputDevice.mt.__index = LibinputDevice

function LibinputDevice.create(obj)
    local device = {
        obj = obj,
        done = false,
        tap_fingers = 0,
    }
    setmetatable(device, LibinputDevice.mt)
    obj:set_user_data(device)
    obj:add_listener(LibinputDevice.listener)
    table.insert(libinput_devices, device)
    return device
end

local function state(value)
    if value == true or value == "enabled" or value == "true" then
        return 1
    elseif value == false or value == "disabled" or value == "false" then
        return 0
    end
end

function LibinputDevice:set(description, result)
    local name = self.input ~= nil and self.input.name or "device"
    result:add_listener {
        ["success"] = function () end,
        ["unsupported"] = function ()
            warn(("%s is not supported by %s"):format(description, name))
        end,
        ["invalid"] = function ()
            warn(("%s is invalid for %s"):format(description, name))
        end,
    }
end

function LibinputDevice:apply(rule)
    if self.applied then
        return
    end
    self.applied = true

    local tap = state(rule.tap)
    if tap ~= nil then
        if self.tap_fingers > 0 then
            self:set("tap", self.obj:set_tap(tap))
        else
            warn(("tap is not supported by %s"):format(
                self.input ~= nil and self.input.name or "device"))
        end
    end

    local accel = tonumber(rule["pointer-accel"])
    if accel ~= nil then
        local speed = math.max(-1, math.min(1, accel))
        if speed ~= accel then
            warn(("pointer-accel for %s clamped to %.2f"):format(
                self.input ~= nil and self.input.name or "device", speed))
        end
        self:set("pointer-accel",
            self.obj:set_accel_speed(wau.wl_array.from({ speed }, "f64")))
    end
end

function LibinputDevice:maybe_destroy()
    if self.removed then
        self.obj:destroy()
    else
        return self
    end
end

function LibinputDevice.listener:removed()
    self:get_user_data().removed = true
end
function LibinputDevice.listener:input_device(obj)
    local device = self:get_user_data()
    libinput_by_input_id[obj:get_id()] = device
    local input = obj:get_user_data()
    if input ~= nil then
        device.input = input
        input.libinput = device
        input:apply()
    end
end
function LibinputDevice.listener:tap_support(fingers)
    self:get_user_data().tap_fingers = fingers
end
function LibinputDevice.listener:done()
    local device = self:get_user_data()
    device.done = true
    if device.input ~= nil then
        device.input:apply()
    end
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
        local output = window.output
        if output == nil or output.removed then
            output = window_output(window)
        end
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
        if wm.tiling then
            window.floating = true
        end
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
        if wm.tiling then
            window.floating = true
        end
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
    elseif action == "toggle-floating" then
        if self.focused ~= nil then
            self.focused.floating = not self.focused.floating
            invalidate_layout()
        end
    elseif action == "float" then
        if self.focused ~= nil then
            self.focused.floating = true
            invalidate_layout()
        end
    elseif action == "tile" then
        wm.tiling = true
        if self.focused ~= nil then
            self.focused.floating = false
        end
        invalidate_layout()
    elseif action == "toggle-tiling" then
        wm.tiling = not wm.tiling
        invalidate_layout()
    elseif action == "increase-main-ratio" then
        layout_main_ratio = math.max(0.1, math.min(0.9, layout_main_ratio + 0.05))
        invalidate_layout()
    elseif action == "decrease-main-ratio" then
        layout_main_ratio = math.max(0.1, math.min(0.9, layout_main_ratio - 0.05))
        invalidate_layout()
    elseif action == "set-gaps" then
        layout_gaps = math.max(0, number(command[2]))
        layout_smart_gaps = false
        invalidate_layout()
    elseif action == "toggle-smart-gaps" then
        layout_smart_gaps = not layout_smart_gaps
        invalidate_layout()
    elseif action == "exit" then
        globals["river_window_manager_v1"]:exit_session()
    else
        print("Seat:action: unimplemented", action)
    end
end

local repeat_state = nil

function Seat:start_repeat(binding, command)
    if repeat_rate <= 0 then
        return
    end
    repeat_state = {
        seat = self,
        binding = binding,
        command = command,
        interval = 1000 / repeat_rate,
        next = monotonic_ms() + repeat_delay,
    }
end

function Seat:stop_repeat(binding)
    if repeat_state ~= nil and repeat_state.binding == binding then
        repeat_state = nil
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

function Seat:add_xkb_binding(key, mods, command, on_release, is_repeat)
    local keysym = xkbcommon.keysym(key)
    local obj = globals["river_xkb_bindings_v1"]:get_xkb_binding(
                    self.obj, keysym, mods)
    local binding = { obj = obj }

    obj:add_listener {
        ["pressed"] = function (_)
            if not on_release then
                self.pending_action = command
                if is_repeat then
                    self:start_repeat(binding, command)
                end
            end
        end,
        ["released"] = function (_)
            if on_release then
                self.pending_action = command
            end
            if is_repeat then
                self:stop_repeat(binding)
            end
        end,
        ["stop_repeat"] = function (_)
            if is_repeat then
                self:stop_repeat(binding)
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
                binding.key, binding.mods, binding.command,
                binding.on_release, binding.is_repeat)
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
        if repeat_state ~= nil and repeat_state.seat == self then
            repeat_state = nil
        end
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
    table_filter_inplace(input_devices, InputDevice.maybe_destroy)
    table_filter_inplace(libinput_devices, LibinputDevice.maybe_destroy)

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

    wm.tile()

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
ffi.C.unsetenv("WAYLAND_DEBUG")

-- Ensure children are automatically reaped
ffi.C.signal(SIGCHLD, SIG_IGN)

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

        local global = globals[iface]
        if global ~= nil then
            if iface == "river_input_manager_v1" then
                global:add_listener {
                    ["input_device"] = function (_, obj)
                        InputDevice.create(obj)
                    end,
                }
            elseif iface == "river_libinput_config_v1" then
                global:add_listener {
                    ["libinput_device"] = function (_, obj)
                        LibinputDevice.create(obj)
                    end,
                }
            end
        end
    end,
}

display:roundtrip()

for k in pairs(required_globals) do
    assert(globals[k] ~= nil, ("wayland compositor does not support %s"):format(k))
end

globals["river_window_manager_v1"]:add_listener(wm_handlers)

-- Fire the next queued repeat, if any is due.  The action is handed to the
-- seat through pending_action so it runs inside the normal manage cycle.
local function repeat_tick()
    if repeat_state == nil then
        return
    end
    local now = monotonic_ms()
    if now < repeat_state.next then
        return
    end

    local seat = repeat_state.seat
    if seat.removed then
        repeat_state = nil
        return
    end

    repeat_state.next = now + repeat_state.interval
    seat.pending_action = repeat_state.command
    globals["river_window_manager_v1"]:manage_dirty()
end

-- Time until the next repeat, or -1 to wait for wayland events forever.
local function repeat_timeout()
    if repeat_state == nil then
        return -1
    end
    local remaining = repeat_state.next - monotonic_ms()
    if remaining <= 0 then
        return 0
    end
    return math.ceil(remaining)
end

-- Wayland event loop with a poll timeout so held keys can repeat without
-- blocking on the compositor file descriptor.
local function event_loop()
    local pointer = ffi.cast("struct wl_display*", display)
    local fd = raw.wl_display_get_fd(pointer)
    local pfd = ffi.new("struct pollfd[1]")
    pfd[0].fd = fd
    pfd[0].events = POLLIN

    while true do
        display:flush()
        pfd[0].revents = 0

        local ready = ffi.C.poll(pfd, 1, repeat_timeout())
        if ready < 0 then
            local err = ffi.C.__errno_location()[0]
            if err ~= EINTR then
                local msg = ffi.string(ffi.C.strerror(err))
                io.stderr:write("wm: poll: " .. msg .. "\n")
                os.exit(1)
            end
        else
            local revents = tonumber(pfd[0].revents)
            if (revents & POLLIN) ~= 0 then
                if not display:dispatch() then
                    break
                end
            elseif (revents & (POLLERR | POLLHUP)) ~= 0 then
                break
            else
                -- Timed out for a key repeat; process anything already queued.
                raw.wl_display_dispatch_pending(pointer)
            end
        end

        repeat_tick()
    end
end

start()

event_loop()
