local wezterm = require 'wezterm'
local config = wezterm.config_builder()

-- set the keybindings to be the ones defined by the table in the settings file
local settings = require "settings/init"
config.keys = settings.mappings.wezterm

-- ctrl + shift + p for command pallet

-- TODO detect OS
config.default_prog = { 'wsl.exe', '--user', 'aqua', '--cd', '~' }

-- config.color_scheme = 'Everblush (Gogh)'
config.color_scheme = 'Dracula (Official)'

config.font = wezterm.font('BigBlueTermPlus Nerd Font')
config.font_size = 11
config.default_cursor_style = 'BlinkingBar'

config.window_background_opacity = 0.2
config.hide_tab_bar_if_only_one_tab = true
config.enable_tab_bar = false

return config
