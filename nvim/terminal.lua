-- AQUAMOON file for configuring nvim's terminal
-- define terminal environment variables
function Let(name, value)
	vim.cmd("let $" .. name .. " = \'" .. value .. "\'")
end

Let('HISTSIZE', '10000')
Let('SAVEHIST', '10000')

local theme = require "settings".theme
Let("PS1", "%F{#" .. theme.fg .. "}%1~%k 󰈿 %f")
Let("BAT_THEME", "fly16")

Let('PAGER', 'bat') -- alternatives: more, nvim

Let('PATH', os.getenv('PATH') .. ':/home/aqua/.local/bin')
Let('LUA_PATH', '/home/aqua/.aquamoon/?/?.lua;/home/aqua/.aquamoon/?.lua;;')

-- catppuccin
-- Let('FZF_DEFAULT_OPTS',
-- '--color=fg:#f8f8f2,bg:#282a36,hl:#bd93f9 --color=fg+:#f8f8f2,bg+:#44475a,hl+:#bd93f9 --color=info:#ffb86c,prompt:#50fa7b,pointer:#ff79c6 --color=marker:#ff79c6,spinner:#ffb86c,header:#6272a4')

-- moonfly
Let('FZF_DEFAULT_OPTS',
	'--color=fg:#b2b2b2,bg:#080808,hl:#f09479 --color=fg+:#e4e4e4,bg+:#262626,hl+:#f09479 --color=info:#cfcfb0,prompt:#80a0ff,pointer:#ff5189 --color=marker:#f09479,spinner:#36c692,header:#80a0ff')

Let('DDGR_COLORS', 'fHgffH')

-- TODO put aliases here?
