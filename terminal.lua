local hilbish = require 'hilbish'
local lunacolors = require 'lunacolors'

hilbish.opts = {
	autocd = true,
	history = true,
	greeting = false,
	motd = false,
	fuzzy = true,
	notifyJobFinish = true,
}

hilbish.prompt(lunacolors.format(
	'{blue}%u {cyan}%d ' .. (fail and '{red}' or '{green}') .. '󰈿 '
))

local ls = "eza --color --icons -F --hyperlink "
os.execute(ls .. hilbish.cwd())

hilbish.alias("df", "duf")
hilbish.alias("du", "dust")
hilbish.alias("q", "exit")
hilbish.alias("l", "clear && " .. ls)
hilbish.alias("ll", ls .. " --all")
hilbish.alias("lg", "lazygit")
hilbish.alias("paru", "paru --bottomup")
hilbish.alias("chmodx", "sudo chmod u+x")
