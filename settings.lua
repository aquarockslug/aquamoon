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
	theme_list = {
		{ "Grey",   "sweetie" },
		{ "Purple", "moonfly" },
		{ "Blue",   "bluloco" },
	},
	river_options = {
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
		{
			"dbus-update-activation-environment",
			"DISPLAY",
			"WAYLAND_DISPLAY",
			"XDG_SESSION_TYPE",
			"XDG_CURRENT_DESKTOP",
		},
		{
			-- TODO use screensaver.lua
			"swayidle timeout 1800 'gtklock'",
		},
		{
			"dunst"
		},
		{
			"swaybg --image " .. theme.background_image,
		},
		{
			"river-luatile"
		},
		{
			"lua " .. os.getenv("HOME") .. "/.aquamoon/scripts/low_battery_warning.lua"
		},
	},
	window_rules = {
		["ssd"] = {
			"firefox", "gimp", "neovide", "steam",
			"com.system76.CosmicFiles", "mpv", "imv",
			"qutebrowser", "glide-glide"
		}
	},

	terminal = {
		aliases = {
			["df"] = "duf",
			["du"] = "dust",
			["top"] = "htop",
			["s"] = "sudo",
			["q"] = "exit",
			["ls"] = "eza --color --icons -F --hyperlink ",
			["l"] = "clear && eza --color --icons -F --hyperlink ",
			["ll"] = "eza --color --icons -F --hyperlink  -la",
			["lg"] = "lazygit",
			["put"] = "wl-paste",
			["yank"] = "wl-copy",
			["paru"] = "paru --bottomup",
			["chmodx"] = "sudo chmod u+x",
			["ddgr"] = "ddgr --reverse",
			["hist"] = "cat ~/.local/share/hilbish/.hilbish-history",
		},
		hilbish_opts = {
			autocd = true,
			history = true,
			greeting = false,
			motd = false,
			fuzzy = true,
			notifyJobFinish = true,
		},
		prompt = {
			cyan = '{cyan}',
			red = '{red}',
			flag = '󰈿 ',
		},
	},

	nvim = {
		godot_executable = "/bin/godot3",
		lazygit = {
			scaling_factor = 1,
			border_chars = { '', '', '', '', '', '', '', '' },
		},
		flag = "󰈿",
		diagnostics = {
			signs = false,
			virtual_lines = true,
			enable = false,
		},
		leader = {
			key = ",",
			mapleader = ",",
			maplocalleader = ",",
		},
		plugins = {
			hipatterns = {
				WARN = { pattern = "%f[%w]()WARN()%f[%W]", group = "MiniHipatternsWarn" },
				HACK = { pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHipatternsHack" },
				TODO = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
			},
			starter = {
				recent_files_count = 20,
				padding = { 0, 5 },
			},
			unconfigured_mini = {
				"ai",
				"align",
				"basics",
				"bracketed",
				"comment",
				"diff",
				"icons",
				"jump",
				"keymap",
				"move",
				"pairs",
				"sessions",
				"surround",
				"trailspace",
				"visits",
			},
			tv = {
				channels = {
					files = { keybinding = '<leader>f' },
					text = { keybinding = '<leader>g' },
				},
			},
			snipe = {
				position = "center",
				text_align = "file-first",
				navigate = { open_vsplit = "e", open_split = "E" },
			},
			cling = {
				wrappers = {
					{ command = "Lg",     binary = "lazygit",                                                           close_on_exit = true },
					{ command = "Serve",  binary = "simple-http-server",                                                close_on_exit = true },
					{ command = "Theme",  binary = "lua " .. os.getenv("HOME") .. "/.aquamoon/scripts/theme_picker.lua" },
					{ command = "Deploy", binary = "lua ./deploy.lua" },
					{ command = "Far",    binary = "scooter",                                                           close_on_exit = true },
					{ command = "AI",     binary = "opencode",                                                          close_on_exit = true },
					{ command = "DDGR",   binary = "ddgr",                                                              close_on_exit = true },
				},
			},
		},
	},
}
