local theme = require "settings/theme"

M = {
	river_options = {
		-- Theme options
		["border-width"] = theme.border_width,
		["border-color-focused"] = "0x" .. theme.fg,
		["border-color-unfocused"] = "0x" .. theme.bg,
		["set-repeat"] = { 50, 300 },
		["focus-follows-cursor"] = "normal",
		["attach-mode"] = "right",
		["default-layout"] = "luatile",
		["output-layout"] = "luatile",
	},
	startup_commands = {
		-- Inform dbus about the environment variables
		{
			"dbus-update-activation-environment",
			"DISPLAY",
			"WAYLAND_DISPLAY",
			"XDG_SESSION_TYPE",
			"XDG_CURRENT_DESKTOP",
		},
		-- Startup programs
		{
			"swayidle",
			'timeout 3600 "swaylock --color 232A2E"', -- lock the screen after an hour
		},
		{
			"swaync",
		},
		{
			"swaybg --image /home/aqua/.aquamoon/snow_leopard_green.jpg"
		}
	},
	gsettings = {
		["org.gnome.desktop.interface"] = {
			["gtk-theme"] = "Colloid-Green-Dark-Everforest",
			["icon-theme"] = "Everforest-Dark",
			-- ["cursor-theme"] = "",
			-- ["cursor-size"] = 24,
		},
	},
	window_rules = { ["ssd"] = { "firefox" } }, -- use server side decorations
	mappings = require("settings/mappings")
}
return M
