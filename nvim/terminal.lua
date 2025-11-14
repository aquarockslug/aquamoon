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

Let('PAGER', "bat --theme fly16 --style=-numbers") -- alternatives: more, nvim

Let('PATH', os.getenv('PATH') .. ':/home/aqua/.local/bin')
Let('LUA_PATH', '/home/aqua/.aquamoon/?/?.lua;/home/aqua/.aquamoon/?.lua;;')

Let('DDGR_COLORS', 'fHgffH')

-- TODO put aliases here?
