
local wezterm = require 'wezterm'
local config = wezterm.config_builder()

-- ctrl + shift + p for command pallet

-- TODO detect OS
wsl=false
if wsl then 
	config.default_prog = { 'wsl.exe' } 
else 
	config.default_prog = { 'zsh' } 
end 

-- config.color_scheme = 'Everblush (Gogh)'
config.color_scheme = 'Dracula (Official)'

config.font = wezterm.font('BigBlueTermPlus Nerd Font')
config.font_size = 14
config.default_cursor_style = 'BlinkingBar'

config.window_background_opacity = 0.2
config.hide_tab_bar_if_only_one_tab = true
config.enable_tab_bar = false
-- config.tab_bar_at_bottom = true

return config
