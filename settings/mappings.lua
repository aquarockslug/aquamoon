local lua_script = function(script_name)
	local script_path = "/home/aqua/.aquamoon/scripts/"
	return { "spawn", [['sh -c "lua ]] .. script_path .. script_name .. [[.lua"']] }
end
local terminal_app = function(app)
	return { "spawn", [['neovide term://"]] .. app .. [["']] }
end

local mappings = {}
mappings.map = {
	normal = {
		-- Terminal
		{
			mod = { "Super" },
			key = "Return",
			command = { "spawn", [[ "neovide --no-tabs --mouse-cursor-icon i-beam" ]] },
		},
		-- Browser
		{
			mod = { "Super", "Shift" },
			key = "Return",
			command = { "spawn", "glide-bin" },
		},
		-- Launcher
		{
			mod = { "Super" },
			key = "D",
			command = lua_script("run"),
		},
		{
			mod = { "Super" },
			key = "Z",
			command = lua_script("system_menu"),
		},
		{
			mod = { "Super" },
			key = "W",
			command = lua_script("networkmanager"),
		},
		{
			mod = { "Super" },
			key = "T",
			command = lua_script("theme_picker"),
		},
		-- Brightness
		{
			mod = { "Super" },
			key = "V",
			command = lua_script("lower_brightness"),
		},
		{
			mod = { "Super" },
			key = "M",
			command = lua_script("raise_brightness"),
		},
		-- Volume
		{
			mod = { "Super" },
			key = "B",
			command = lua_script("lower_volume"),
		},
		{
			mod = { "Super" },
			key = "N",
			command = lua_script("raise_volume"),
		},
		-- Screenshot
		{
			mod = { "Super" },
			key = "S",
			command = lua_script("screenshot"),
		},
		-- Close
		{
			mod = "Super",
			key = "Q",
			command = "close",
		},
		-- Super+{J,K} to focus next/previous view in the layout stack
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
		-- Super+Shift+{J,K} to swap focused view with the next/previous view in the layout stack
		{
			mod = { "Super", "Shift" },
			key = "J",
			command = { "swap", "previous" },
		},
		{
			mod = { "Super", "Shift" },
			key = "K",
			command = { "swap", "next" },
		},
		-- Super+E to bump the focused view to the top of the layout stack
		{
			mod = "Super",
			key = "E",
			command = "zoom",
		},
		-- Super+F to toggle fullscreen
		{
			mod = "Super",
			key = "F",
			command = "toggle-fullscreen",
		},
		-- Super+{H,L} to decrease/increase the main_factor value of luatile by 0.02
		{
			mod = { "Super" },
			key = "H",
			command = { "send-layout-cmd", "luatile", [[ "modify_main_ratio(-1)" ]] },
		},
		{
			mod = { "Super" },
			key = "L",
			command = { "send-layout-cmd", "luatile", [[ "modify_main_ratio(1)" ]] },
		},
	},
}

-- mappings for pointer (mouse)
mappings["map-pointer"] = {
	normal = {
		-- Super + Left Mouse Button to move views
		{
			mod = "Super",
			key = "BTN_LEFT",
			command = "move-view",
		},
		-- Super + Right Mouse Button to resize views
		{
			mod = "Super",
			key = "BTN_RIGHT",
			command = "resize-view",
		},
	},
}

return mappings
