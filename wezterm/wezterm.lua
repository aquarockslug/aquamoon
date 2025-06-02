local wezterm = require 'wezterm'
local act = wezterm.action
local config = wezterm.config_builder()

-- ctrl + shift + p for command pallet

-- TODO detect OS
config.default_prog = { 'wsl.exe', '--user', 'aqua', '--cd', '~' }

-- config.color_scheme = 'Everblush (Gogh)'
config.color_scheme = 'Dracula (Official)'

config.font = wezterm.font('BigBlueTermPlus Nerd Font')
config.font_size = 10
config.default_cursor_style = 'BlinkingBar'

config.window_background_opacity = 0.2
config.hide_tab_bar_if_only_one_tab = true
config.enable_tab_bar = false

config.keys = {
	{
		mods = 'CTRL',
		key = 'p',
		action = act.SplitHorizontal {},
	},
	{
		mods = 'SHIFT|CTRL',
		key = 'p',
		action = act.CloseCurrentPane {},
	},
	{
		mods = 'CTRL',
		key = 'o',
		action = act.SpawnTab {},
	},
	{
		mods = 'SHIFT|CTRL',
		key = 'o',
		action = act.CloseCurrentTab {},
	},
	{
		key = 'LeftArrow',
		mods = 'CTRL',
		action = act.ActivatePaneDirection 'Left',
	},
	{
		key = 'RightArrow',
		mods = 'CTRL',
		action = act.ActivatePaneDirection 'Right',
	},
	{
		key = 'UpArrow',
		mods = 'CTRL',
		action = act.ActivatePaneDirection 'Up',
	},
	{
		key = 'DownArrow',
		mods = 'CTRL',
		action = act.ActivatePaneDirection 'Down',
	},
}

return config
