-- create lua settings table using information from the toml file
toml = require "tinytoml"
toml_settings = toml.parse("/home/aqua/.aquamoon/nvim/rocks.toml")
current_theme_name = toml_settings.config.colorscheme
theme = require("settings/theme").get(current_theme_name)

return {
	path = "/home/aqua/.aquamoon",
	wsl = false,
	mappings = require("settings/mappings"),
	theme_name = current_theme_name,
	theme = theme,
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
			"swayidle timeout 1800 'swaylock'", -- lock the screen after 30 min
		},
		{
			"dunst" -- notifications
		},
		{
			"swaybg --image " .. theme.background_image, -- set background
		},
	},
	gsettings = {
		["org.gnome.desktop.interface"] = {
			-- ["gtk-theme"] = "Dracula",
			-- ["icon-theme"] = "Tela circle dracula dark",
			-- ["cursor-theme"] = "macOS-White",
			-- ["cursor-size"] = 24,
		},
	},
	window_rules = { ["ssd"] = { "firefox", "gimp" } }, -- use server side decorations
}
