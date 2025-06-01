local settings = require "settings"
local aqua_path = settings.path

-- system path, aqua configuration path
Symlinks = {
	neovim = { "~/.config/nvim", aqua_path .. "/nvim" },
	river = { "~/.config/river/init", aqua_path .. "/river" },
	wezterm = { "~/.config/wezterm/wezterm.lua", aqua_path .. "/wezterm.lua" },
	zellij = { "~/.config/zellij", aqua_path .. "/zellij" },
	zshell = { "~/.zshrc", aqua_path .. "/zsh/zshrc" },
}

-- change the system path for wezterm if using Windows Subsystem Linux
if settings.wsl then Symlinks.westerm[1] = "/mnt/c/Users/aquarock/.wezterm" end

-- TODO loop through symbolic link table to ensure all symbolic links exist

print(Symlinks.zshell[2])
