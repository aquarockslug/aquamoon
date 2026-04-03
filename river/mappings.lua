-- River window manager key mappings for Aquamoon
-- Defines keyboard and mouse bindings for launching apps and window management

local M = {}

local function lua_script(script_name)
	local script_path = os.getenv("HOME") .. "/.aquamoon/scripts/"
	return { "spawn", [['sh -c "lua ]] .. script_path .. script_name .. [[.lua"']] }
end

local function terminal_app(app)
	return { "spawn", [['neovide term://"]] .. app .. [["']] }
end

M.map = {
	normal = {
		{
			mod = { "Super" },
			key = "Return",
			command = { "spawn", [[ "neovide --no-tabs" ]] },
		},
		{
			mod = { "Super" },
			key = "S",
			command = lua_script("ui_browse"),
		},
		{
			mod = { "Super" },
			key = "A",
			command = lua_script("ui_bookmarks"),
		},
		{
			mod = { "Super" },
			key = "D",
			command = lua_script("ui_run"),
		},
		{
			mod = { "Super" },
			key = "Z",
			command = lua_script("ui_system_menu"),
		},
		{
			mod = { "Super" },
			key = "W",
			command = lua_script("ui_networkmanager"),
		},
		{
			mod = { "Super" },
			key = "T",
			command = lua_script("theme_picker"),
		},
		{
			mod = { "Super" },
			key = "V",
			command = lua_script("media_lower_brightness"),
		},
		{
			mod = { "Super" },
			key = "M",
			command = lua_script("media_raise_brightness"),
		},
		{
			mod = { "Super" },
			key = "B",
			command = lua_script("media_lower_volume"),
		},
		{
			mod = { "Super" },
			key = "N",
			command = lua_script("media_raise_volume"),
		},
		{
			mod = { "Super", "Shift" },
			key = "S",
			command = lua_script("util_screenshot"),
		},
		{
			mod = "Super",
			key = "Q",
			command = "close",
		},
		{
			mod = "Super",
			key = "E",
			command = "zoom",
		},
		{
			mod = "Super",
			key = "F",
			command = "toggle-fullscreen",
		},
		{
			mod = "Super",
			key = "J",
			command = { "focus-view", "previous" },
		},
		{
			mod = "Super",
			key = "K",
			command = { "focus-view", "next" },
		},
		{
			mod = { "Super", "Shift" },
			key = "H",
			command = { "send-layout-cmd", "luatile", [[ "modify_main_ratio(-1)" ]] },
		},
		{
			mod = { "Super", "Shift" },
			key = "L",
			command = { "send-layout-cmd", "luatile", [[ "modify_main_ratio(1)" ]] },
		},
		{
			mod = { "Super" },
			key = "H",
			command = { "set-focused-tags", "1" },
		},
		{
			mod = { "Super" },
			key = "L",
			command = { "set-focused-tags", "2" },
		},
	},
}

M["map-pointer"] = {
	normal = {
		{
			mod = "Super",
			key = "BTN_LEFT",
			command = "move-view",
		},
		{
			mod = "Super",
			key = "BTN_RIGHT",
			command = "resize-view",
		},
	},
}

return M
