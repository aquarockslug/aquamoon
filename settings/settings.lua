local rocks_path = "/home/aqua/.local/share/nvim/rocks/share/lua/5.1/?.lua;"
rocks_path = rocks_path .. "/home/aqua/.local/share/nvim/rocks/share/lua/5.1/?/init.lua;"
local rocks_cpath = "/home/aqua/.local/share/nvim/rocks/lib/lua/5.1/?.so;"
rocks_cpath = rocks_cpath .. "/home/aqua/.local/share/nvim/rocks/lib64/lua/5.1/?.so;"
local aquamoon_path = '/home/aqua/.aquamoon/?.lua;/home/aqua/.aquamoon/?/?.lua;'
package.path = package.path .. rocks_path .. aquamoon_path .. ";"
package.cpath = package.cpath .. rocks_cpath .. ";"

-- create lua settings table using information from the toml file
get_theme_from_toml = function()
	toml_settings = require("tinytoml").parse("/home/aqua/.aquamoon/nvim/rocks.toml")
	current_theme_name = toml_settings.config.colorscheme

	-- map nvim colorscheme name to aquamoon config names
	if current_theme_name == "sweetie" then
		return require("settings/theme").get("sweetie")
	end

	if current_theme_name == "dracula" or current_theme_name == "dracula-soft" then
		return require("settings/theme").get("dracula")
	end

	if current_theme_name == "OceanicNext" or current_theme_name == "minicyan" then
		return require("settings/theme").get("OceanicNext")
	end

	if current_theme_name == "srcery" then
		return require("settings/theme").get("srcery")
	end

	if current_theme_name == "moonfly" or current_theme_name == "eldritch" then
		return require("settings/theme").get("moonfly")
	end

	-- default to sweetie
	return require("settings/theme").get("sweetie")
end

choose_theme_by_hour = function()
	local theme_list = { "dracula", "sweetie" }
	local theme_name = theme_list[math.ceil(tonumber(os.date("%H")) / 24 * #theme_list)]
	return require("settings/theme").get(theme_name)
end

theme = get_theme_from_toml()

return {
	path = "/home/aqua/.aquamoon",
	mappings = require("settings/mappings"),
	theme_name = theme.name,
	theme = theme,
	theme_list = {
		"OceanicNext",
		"dracula-soft",
		"eldritch",
		"minicyan",
		"moonfly",
		"srcery",
		"sweetie",
		-- "apprentice",
		-- "bamboo",
		-- "desert",
		-- "mellifluous",
		-- "minischeme",
		-- "neofusion",
		-- "nvim-tundra",
		-- "seoul256",
		-- "unokai"
		-- "vague",
		-- "vim-colors-paramount"
		-- "vim-pink-moon"
	},
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
			"swayidle timeout 1800 'gtklock'", -- lock the screen after 30 min
		},
		{
			"dunst" -- notifications
		},
		{
			"swaybg --image " .. theme.background_image, -- set background
		},
		{
			"river-luatile"
		},
		{
			"lua ~/.aquamoon/scripts/low_battery_warning.lua"
		},
		{
			"clipse -listen-shell"
		}
	},
	window_rules = {
		-- use server side decorations
		["ssd"] = {
			"glide-glide", "gimp", "neovide", "steam", "qutebrowser",
			"libreoffice-writer", "libreoffice-startcenter",
			"com.system76.CosmicFiles", "com.system76.CosmicPlayer", "org.gnome.Loupe"
		}
	},
}
