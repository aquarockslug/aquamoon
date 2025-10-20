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

	if current_theme_name == "moonfly" then
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

theme = require("settings/theme").get("moonfly")

return {
	path = "/home/aqua/.aquamoon",
	mappings = require("settings/mappings"),
	theme_name = "moonfly",
	theme = theme,
	wsl = false,
	theme_list = {
		"OceanicNext",
		"dracula-soft",
		"minicyan", -- TODO add a background
		"moonfly",
		"srcery",
		"sweetie",
		-- "vague",
		-- "apprentice",
		-- "bamboo",
		-- "desert",
		-- "mellifluous",
		-- "minischeme",
		-- "neofusion",
		-- "nvim-tundra",
		-- "seoul256",
		-- "unokai"
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
			-- "swayidle timeout 1800 'gtklock'", -- lock the screen after 30 min
			"stasis"
		},
		{
			"dunst" -- notifications
		},
		{
			"swaybg --image " .. theme.background_image, -- set background
		},
		{
			"river-luatile"
		}
	},
	gsettings = {
		["org.gnome.desktop.interface"] = {
			-- ["gtk-theme"] = "Dracula",
			-- ["icon-theme"] = "Tela circle dracula dark",
			-- ["cursor-theme"] = "macOS-White",
			-- ["cursor-size"] = 24,
		},
	},
	window_rules = { ["ssd"] = { "firefox", "glide-bin", "gimp" } }, -- use server side decorations
}
