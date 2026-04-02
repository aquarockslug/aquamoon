-- Central settings module for Aquamoon
-- Loads and parses TOML configuration files, manages themes

local M = {}

package.path = package.path .. ";" .. os.getenv("HOME") .. "/.local/share/nvim/rocks/share/lua/5.1/?.lua"
package.path = package.path .. ";" .. os.getenv("HOME") .. "/.local/share/nvim/rocks/share/lua/5.1/?/init.lua"

local TT = dofile(os.getenv("HOME") .. "/.aquamoon/scripts/tinytoml.lua")

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
		["selection-color"] = theme.text_secondary,
		["border-width"] = theme.border_width,
		["text-color"] = theme.text_primary,
		["border-color"] = theme.background_alt,
		["background-color"] = theme.background,
		["text-cursor"] = "true",
		["result-spacing"] = 9,
		anchor = "bottom",
		["margin-bottom"] = theme.border_width
	}
	return theme
end

local nvim_settings = TT.parse(os.getenv("HOME") .. "/.aquamoon/rocks.toml")
local current_theme_name = nvim_settings.config.colorscheme

current_theme_name = string.gsub(current_theme_name, "-", "_") -- nvim uses "-" but themes.toml uses "_"
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

local river_opts = config.river_options
river_opts["border-color-focused"] = "0x" .. theme.accent
river_opts["border-color-unfocused"] = "0x" .. theme.text_secondary
M.river_options = river_opts
M.startup_commands = startup_config
M.window_rules = config.window_rules
M.terminal = terminal_config
M.nvim = config.nvim
M.inputs = input_config

return M

