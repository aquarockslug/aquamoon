-- create lua settings table using information from the toml file

get_theme_from_toml = function()
	toml_settings = require("tinytoml").parse("/home/aqua/.aquamoon/nvim/rocks.toml")
	current_theme_name = toml_settings.config.colorscheme

	if current_theme_name == "sweetie" or current_theme_name == "dracula" then
		return require("settings/theme").get(current_theme_name)
	end

	if current_theme_name == "dracula-soft" then
		return require("settings/theme").get("dracula")
	end

	if current_theme_name == "OceanicNext" then
		return require("settings/theme").get("OceanicNext")
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
	theme_name = current_theme_name,
	theme = theme,
	wsl = false,
	theme_list = {
		"OceanicNext",
		"catppuccin-frappe",
		"dracula-soft",
		"sweetie",
		-- "desert",
		-- "dracula",
		-- "minicyan", TODO
		-- "minischeme",
		-- "moonfly", TODO
		-- "nightfly",
		-- "unokai"
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
