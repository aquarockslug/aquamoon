local wezterm = require 'wezterm'
local act = wezterm.action
local config = wezterm.config_builder()

-- ctrl + shift + p for command pallet

-- TODO detect OS
-- config.default_prog = { 'wsl.exe', '--user', 'aqua', '--cd', '~' }
config.default_prog = { 'zsh' }


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
		mods = 'ALT',
		key = 'm',
		action = act.SplitVertical {},
	},
	{
		mods = 'ALT',
		key = 'n',
		action = act.SplitHorizontal {},
	},
	{
		mods = 'ALT',
		key = 'x',
		action = act.CloseCurrentPane { confirm = false },
	},
	{
		mods = 'ALT',
		key = 'y',
		action = act.SpawnTab 'DefaultDomain',
	},
	{
		mods = 'ALT',
		key = 'u',
		action = act.ShowTabNavigator,
	},
	{
		mods = 'ALT',
		key = 'h',
		action = act.ActivatePaneDirection 'Left',
	},
	{
		mods = 'ALT',
		key = 'l',
		action = act.ActivatePaneDirection 'Right',
	},
	{
		mods = 'ALT',
		key = 'k',
		action = act.ActivatePaneDirection 'Up',
	},
	{
		mods = 'ALT',
		key = 'j',
		action = act.ActivatePaneDirection 'Down',
	},
}

return config
