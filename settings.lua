local rocks_path = os.getenv("HOME") .. "/.local/share/nvim/rocks/share/lua/5.1/?.lua;"
rocks_path = rocks_path .. os.getenv("HOME") .. "/.local/share/nvim/rocks/share/lua/5.1/?/init.lua;"
local rocks_cpath = os.getenv("HOME") .. "/.local/share/nvim/rocks/lib/lua/5.1/?.so;"
rocks_cpath = rocks_cpath .. os.getenv("HOME") .. "/.local/share/nvim/rocks/lib64/lua/5.1/?.so;"
package.path = package.path .. rocks_path .. ";"
package.cpath = package.cpath .. rocks_cpath .. ";"

TT = dofile(os.getenv("HOME") .. "/.aquamoon/etc/tinytoml.lua")

get_theme = function(name)
	local toml = TT.parse(os.getenv("HOME") .. "/.aquamoon/themes.toml")
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

choose_theme_from_nvim = function()
	local toml_settings = TT.parse(os.getenv("HOME") .. "/.aquamoon/nvim/rocks.toml")
	local current_theme_name = toml_settings.config.colorscheme

	-- map nvim colorscheme names to aquamoon config names
	local theme_mappings = {
		["sweetie"] = "sweetie",
		["challenger_deep"] = "sweetie",
		["dracula"] = "dracula",
		["dracula-soft"] = "dracula",
		["eldritch"] = "dracula",
		["eldritch-minimal"] = "dracula",
		["moonfly"] = "moonfly",
		["boo"] = "moonfly",
		["OceanicNext"] = "OceanicNext",
		["minicyan"] = "OceanicNext",
		["srcery"] = "srcery",
		["mfd-amber"] = "srcery",
		["mfd-flir-fusion"] = "srcery",
		["iceclimber"] = "iceclimber",
		["dogrun"] = "iceclimber",
		["seoul256"] = "iceclimber",
		["bluloco"] = "bluloco"
	}

	return theme_mappings[current_theme_name] or "sweetie"
end

choose_theme_by_hour = function()
	local theme_list = { "dracula", "sweetie" }
	local theme_name = theme_list[math.ceil(tonumber(os.date("%H")) / 24 * #theme_list)]
	return theme_name
end

theme = get_theme(choose_theme_from_nvim())

return {
	path = os.getenv("HOME") .. "/.aquamoon",
	mappings = dofile(os.getenv("HOME") .. "/.aquamoon/mappings.lua"),
	theme_name = theme.name,
	theme = theme,
	theme_list = {
		"boo",
		"dracula-soft",
		"OceanicNext",
		"eldritch-minimal",
		"moonfly",
		"srcery",
		"sweetie",
		"challenger_deep",
		"mfd-flir-fusion",
		"bluloco",
		-- "seoul256",
		-- "mfd-amber",
		-- "minicyan",
		-- "iceclimber",
		-- "dogrun",
		-- "apprentice", "bamboo", "desert", "mellifluous", "minischeme", "neofusion",
		-- "nvim-tundra", "seoul256", "unokai", "vague", "vim-colors-paramount", "vim-pink-moon",
		-- "neomodern", "vim-256noir", "yourumi", "challenger-deep-theme"
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
			"lua " .. os.getenv("HOME") .. "/.aquamoon/scripts/low_battery_warning.lua"
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
			"com.system76.CosmicFiles", "mpv", "imv"
		}
	},
}
