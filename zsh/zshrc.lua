-- TODO use this file instead of zshrc

-- os.execute('source /home/aqua/.aquamoon/zsh/lib/dracula.zsh-theme')

-- check if zsh is already running inside nvim to prevent a loop
if os.getenv('NVIM') then os.exit() end

local unistd = require("posix.unistd")
local set = require("posix.stdlib").setenv

set('PATH', os.getenv('PATH') .. ':/home/aqua/.local/bin')
set('LUA_PATH', '/home/aqua/.aquamoon/?/?.lua;/home/aqua/.aquamoon/?.lua;;')

set('ZSH_THEME', 'dracula')
set('TERMINAL', 'foot') -- check if on wsl
set('HISTSIZE', '10000')
set('SAVEHIST', '10000')

set('FZF_DEFAULT_OPTS',
	'--color=fg:#f8f8f2,bg:#282a36,hl:#bd93f9 --color=fg+:#f8f8f2,bg+:#44475a,hl+:#bd93f9 --color=info:#ffb86c,prompt:#50fa7b,pointer:#ff79c6 --color=marker:#ff79c6,spinner:#ffb86c,header:#6272a4')
set('DDGR_COLORS', 'fHgffH')
set('DRACULA_ARROW_ICON', ' 󰈿 ')

-- os.execute('echo ' .. alias_cmd .. ' > /home/aqua/.aquamoon/zsh/zshrc')
os.execute('nvim +Oil')
