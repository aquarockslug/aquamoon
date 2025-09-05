local choose_theme_by_hour = function()
	local theme_list = { "dracula", "sweetie" }
	local theme_name = theme_list[math.ceil(tonumber(os.date("%H")) / 24 * #theme_list)]
	return require("settings/theme").get(theme_name)
end


M = {
	theme = require("settings/theme").get("sweetie"), -- WARN TODO this is required for neovide and tofi
	get = function(theme_name)
		local theme = require("settings/theme").get(theme_name)
		return {
			path = "/home/aqua/.aquamoon",
			wsl = false,
			mappings = require("settings/mappings"),
			-- theme = require("settings/theme").get("sweetie"),
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
					-- 'timeout 3600 "swaylock --color 232A2E"', -- lock the screen after an hour
				},
				{
					"dunst"
				},
				{
					"swaybg --image " .. theme.background_image,
				},
			},
			gsettings = {
				-- these settings overwrite the ones in ~/.config/gtk-3.0
				["org.gnome.desktop.interface"] = {
					["gtk-theme"] = "Dracula",
					["icon-theme"] = "Tela circle dracula dark",
					["cursor-theme"] = "macOS-White",
					["cursor-size"] = 24,
				},
				["org.gnome.desktop.peripherals.touchpad"] = {
					["natural-scroll"] = true,
				},
			},
			window_rules = { ["ssd"] = { "firefox", "gimp" } }, -- use server side decorations
		}
	end
}
return M
