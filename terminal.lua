local hilbish = require 'hilbish'
local lunacolors = require 'lunacolors'

local S = dofile(os.getenv("HOME") .. "/.aquamoon/settings.lua")
local tofi = dofile(S.path .. "/scripts/tofi.lua")

hilbish.opts = {
	autocd = true,
	history = true,
	greeting = false,
	motd = false,
	fuzzy = true,
	notifyJobFinish = true,
}

hilbish.prompt(lunacolors.format(
	'{blue}%u {cyan}%d ' .. (fail and '{red}' or '{cyan}') .. '󰈿 '
))

-- WARN not working
bait.catch("hilbish.cd", function(p, old_p)
	sinks.out:writeln 'Hello world!'
end)

commander.register('hello', function(args, sinks)
	sinks.out:writeln 'Hello world!'
end)

local ls = "eza --color --icons -F --hyperlink "
os.execute(ls .. hilbish.cwd())

hilbish.alias("df", "duf")
hilbish.alias("du", "dust")
hilbish.alias("top", "htop")
hilbish.alias("s", "sudo")
hilbish.alias("q", "exit")
hilbish.alias("l", "clear && " .. ls)
hilbish.alias("ll", ls .. " --all")
hilbish.alias("lg", "lazygit")
hilbish.alias("put", "wl-paste")
hilbish.alias("yank", "wl-copy")
hilbish.alias("paru", "paru --bottomup")
hilbish.alias("chmodx", "sudo chmod u+x")
hilbish.alias("ddgr", "ddgr --reverse")
