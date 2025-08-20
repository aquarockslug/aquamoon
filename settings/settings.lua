local theme = require("settings/theme").get("sweetie")

M = {
	path = "/home/aqua/.aquamoon",
	wsl = false,
	mappings = require("settings/mappings"),
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
			"swayidle",
			'timeout 3600 "swaylock --color 232A2E"', -- lock the screen after an hour
		},
		{
			"swaync",
		},
		{
			"swaybg --image " .. theme.background_image,
		},
		{
			"/home/aqua/.aquamoon/river/bar",
		},
		{
			"avizo-service"
		},
		{
			"/home/aqua/.aquamoon/river/status",
		},
	},
	gsettings = {
		-- these settings overwrite the ones in ~/.config/gtk-3.0
		["org.gnome.desktop.interface"] = {
			-- ["gtk-theme"] = "Dracula",
			-- ["icon-theme"] = "Tela circle dracula dark",
			-- ["cursor-theme"] = "macOS-White",
			-- ["cursor-size"] = 24,
		},
		["org.gnome.desktop.peripherals.touchpad"] = {
			["natural-scroll"] = true,
		},
	},
	window_rules = { ["ssd"] = { "firefox", "thunar", "gimp", "gedit", "foot" } }, -- use server side decorations
}
return M
