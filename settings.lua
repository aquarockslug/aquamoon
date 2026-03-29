-- Central settings module for Aquamoon
-- Loads and parses TOML configuration files, manages themes

local M = {}

package.path = package.path .. ";" .. os.getenv("HOME") .. "/.local/share/nvim/rocks/share/lua/5.1/?.lua"
package.path = package.path .. ";" .. os.getenv("HOME") .. "/.local/share/nvim/rocks/share/lua/5.1/?/init.lua"

local TT = dofile(os.getenv("HOME") .. "/.aquamoon/etc/tinytoml.lua")

local function get_theme(name)
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
local theme = get_theme(current_theme_name or "sweetie")

local config = TT.parse(os.getenv("HOME") .. "/.aquamoon/toml/settings.toml")
local terminal_config = TT.parse(os.getenv("HOME") .. "/.aquamoon/toml/terminal.toml")
local startup_config = TT.parse(os.getenv("HOME") .. "/.aquamoon/toml/startup.toml")
local input_config = TT.parse(os.getenv("HOME") .. "/.aquamoon/toml/inputs.toml")

M.path = os.getenv("HOME") .. "/.aquamoon"
M.mappings = dofile(os.getenv("HOME") .. "/.aquamoon/mappings.lua")
M.theme_name = theme.name
M.theme = theme
M.theme_list = config.theme_list
M.river_options = config.river_options
M.startup_commands = startup_config
M.window_rules = config.window_rules
M.terminal = terminal_config
M.nvim = config.nvim
M.inputs = input_config

return M