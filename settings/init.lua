-- All the setting tables ──────────────────────────────────────────────────────

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
	},
	river_options = {
		-- Theme options
		-- ["xcursor-theme"] = { "Bibata-Modern-Ice", 24 },
		-- ["border-width"] = 2,
		["set-repeat"] = { 50, 300 },
		["focus-follows-cursor"] = "normal",
		["attach-mode"] = "bottom",
		["default-layout"] = "rivertile",
	},
	gsettings = { -- TODO use this table instead of nwg-look
		-- ["org.gnome.desktop.interface"] = {
		-- 	["gtk-theme"] = "Nordic",
		-- 	["icon-theme"] = "Papirus-Dark",
		-- 	["gtk-scale"] = "Nordic",
		-- 	["cursor-theme"] = river_options["xcursor-theme"][1],
		-- 	["cursor-size"] = river_options["xcursor-theme"][2],
		-- },
	},
	window_rules = {
		["float-filter-add"] = {
			["app-id"] = {
				"float",
				"popup",
				"swappy",
			},
			["title"] = {
				"Picture-in-Picture", -- 'About *',
			},
		},
		["csd-filter-add"] = {
			["app-id"] = { "swappy" },
		},
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
