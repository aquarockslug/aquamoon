local rocks_path = os.getenv("HOME") .. "/.local/share/nvim/rocks/share/lua/5.1/?.lua;"
rocks_path = rocks_path .. os.getenv("HOME") .. "/.local/share/nvim/rocks/share/lua/5.1/?/init.lua;"
package.path = package.path .. rocks_path .. ";"

TT = dofile(os.getenv("HOME") .. "/.aquamoon/etc/tinytoml.lua")

get_theme = function(name)
	local toml = TT.parse(os.getenv("HOME") .. "/.aquamoon/toml/themes.toml")
	local theme = toml[name]
	theme.name = name
	theme.tofi = {
		font = theme.active_font.path,
		["font-size"] = theme.active_font.size,
		width = "33%",
		height = "33%",
		["drun-launch"] = "true",
		["outline-width"] = 0,
		["prompt-text"] = "󰈿_",
		["selection-color"] = theme.fg2,
		["border-width"] = theme.border_width,
		["text-color"] = theme.fg,
		["border-color"] = theme.bg2,
		["background-color"] = theme.bg,
		["text-cursor"] = "true",
		["result-spacing"] = 9,
		anchor = "bottom",
		["margin-bottom"] = theme.border_width
	}
	return theme
end

local toml_settings = TT.parse(os.getenv("HOME") .. "/.aquamoon/rocks.toml")
local current_theme_name = toml_settings.config.colorscheme
theme = get_theme(current_theme_name or "sweetie")

return {
	path = os.getenv("HOME") .. "/.aquamoon",
	mappings = dofile(os.getenv("HOME") .. "/.aquamoon/mappings.lua"),
	theme_name = theme.name,
	theme = theme,
	-- map theme name to nvim colorscheme
	theme_list = {
		{ "Grey",   "sweetie" },
		{ "Purple", "moonfly" },
		{ "Blue",   "bluloco" },
		-- { "Teal",   "challenger_deep" },
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
			-- TODO use screensaver.lua as a lock screen
			--
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
			"lua " .. os.getenv("HOME") .. "/.aquamoon/scripts/low_battery_warning.lua"
		},
	},
	window_rules = {
		-- use server side decorations
		["ssd"] = {
			"firefox", "gimp", "neovide", "steam",
			"com.system76.CosmicFiles", "mpv", "imv",
			"qutebrowser", "glide-glide"
		}
	},
}
