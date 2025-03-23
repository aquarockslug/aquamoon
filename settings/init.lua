-- All the setting tables ──────────────────────────────────────────────────────
local theme = require("aquamoon/settings/theme")

M = {
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
			'timeout 300 "swaylock --color 232A2E"',
		},
		{
			"swaync",
		},
		{
			"swaybg --image /home/aqua/.aquamoon/snow_leopard_green.jpg"
		}
	},
	river_options = {
		-- Theme options
		-- ["xcursor-theme"] = { "Bibata-Modern-Ice", 24 },
		["border-width"] = 8,
		["border-color-focused"] = "0x" .. theme.white,
		["border-color-unfocused"] = "0x" .. theme.black,
		["set-repeat"] = { 50, 300 },
		["focus-follows-cursor"] = "normal",
		["attach-mode"] = "bottom",
		["default-layout"] = "rivertile",
	},
	gsettings = { -- TODO use this table instead of nwg-look
		["org.gnome.desktop.interface"] = {
			["gtk-theme"] = "Colloid-Green-Dark-Everforest",
			["icon-theme"] = "Everforest-Dark",
			-- ["gtk-scale"] = "Nordic",
		-- 	["cursor-theme"] = river_options["xcursor-theme"][1],
		-- 	["cursor-size"] = river_options["xcursor-theme"][2],
		},
	},
	window_rules = {
		["float-filter-add"] = {
			["app-id"] = {},
			["title"] = {},
		},
		["csd-filter-add"] = {},
	},
	-- Each mapping contains 4 keys:
	--
	-- mod: string|list (modifiers, concanated by '+')
	-- key: string
	-- command: string|list (the command passed to riverctl)
	-- opt: string ('release' or 'repeat')
	mappings = require("settings/mappings")
}
return M
