-- TODO use this file instead of zshrc
-- generate and write .zshrc?
-- only use lua for exporting env variables?
-- run from /etc/zsh/zprofile before .zshrc is sourced?
-- only use terminal from inside nvim to allow lua only zsh config?

if os.getenv('AQUAMOON_STATE') == 'using_nvim' then os.exit() end

local unistd = require("posix.unistd")
local set = require("posix.stdlib").setenv

set('AQUAMOON_STATE', 'using_nvim')
os.execute('nvim +Oil')

-- set('ZSH_THEME', 'dracula')
-- set('TERM', 'wezterm')

-- export PATH="$PATH:/home/aqua/.local/bin"
-- export LUA_PATH="/home/aqua/.aquamoon/?.lua;;"
-- export TERM="wezterm"
-- export HISTFILE=$HOME/.zsh_history
-- export HISTSIZE=10000
-- export SAVEHIST=10000

-- print(string.format('alias %s="%s"', "iv", "nvim"))
