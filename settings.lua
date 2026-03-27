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

local config = TT.parse(os.getenv("HOME") .. "/.aquamoon/settings.toml")
local terminal_config = TT.parse(os.getenv("HOME") .. "/.aquamoon/terminal.toml")
local startup_config = TT.parse(os.getenv("HOME") .. "/.aquamoon/startup.toml")

return {
	path = os.getenv("HOME") .. "/.aquamoon",
	mappings = dofile(os.getenv("HOME") .. "/.aquamoon/mappings.lua"),
	theme_name = theme.name,
	theme = theme,
	theme_list = config.theme_list,
	river_options = config.river_options,
	startup_commands = startup_config,
	window_rules = config.window_rules,
	terminal = terminal_config,
	nvim = config.nvim,
}
