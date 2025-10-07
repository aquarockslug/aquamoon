-- AQUAMOON file for configuring nvim's terminal
-- define terminal environment variables
function let(name, value)
	vim.cmd("let $" .. name .. " = \'" .. value .. "\'")
end

let('HISTSIZE', '10000')
let('SAVEHIST', '10000')

let("PS1", "%1~%k 󰈿 %f")
let("BAT_THEME", "base16")

let('PATH', os.getenv('PATH') .. ':/home/aqua/.local/bin')
let('LUA_PATH', '/home/aqua/.aquamoon/?/?.lua;/home/aqua/.aquamoon/?.lua;;')
let('FZF_DEFAULT_OPTS',
	'--color=fg:#f8f8f2,bg:#282a36,hl:#bd93f9 --color=fg+:#f8f8f2,bg+:#44475a,hl+:#bd93f9 --color=info:#ffb86c,prompt:#50fa7b,pointer:#ff79c6 --color=marker:#ff79c6,spinner:#ffb86c,header:#6272a4')
let('DDGR_COLORS', 'fHgffH')

-- TODO put aliases here
