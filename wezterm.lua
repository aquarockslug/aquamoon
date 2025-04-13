local wezterm = require 'wezterm'
local config = wezterm.config_builder()

-- ctrl + shift + p for command pallet

-- TODO detect OS
config.default_prog = { 'wsl.exe' }

-- config.color_scheme = 'Everblush (Gogh)'
config.color_scheme = 'Dracula (Official)'

config.font = wezterm.font('BigBlueTermPlus Nerd Font')
config.font_size = 14
config.default_cursor_style = 'BlinkingBar'

config.use_fancy_tab_bar = false
config.show_tabs_in_tab_bar = false
config.show_new_tab_button_in_tab_bar = false

-- TODO
-- config.disable_default_key_bindings = true
-- config.launch_menu = launch_menu

return config
