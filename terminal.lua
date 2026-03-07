local hilbish = require 'hilbish'
local fs = require 'fs'
local bait = require 'bait'
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

-- TODO use hex codes instead of color names S.theme.fg
hilbish.prompt(lunacolors.format(
	'{cyan}%d ' .. (fail and '{red}' or '{cyan}') .. '󰈿 '
))

bait.catch("hilbish.cd", function(dir)
	hilbish.prompt(lunacolors.format(
		'{cyan}' .. dir .. (fail and '{red}' or '{cyan}') .. ' 󰈿 '
	))
end)

commander.register('cd', function(args, sinks)
	fs.cd(args[1])
	bait.throw("hilbish.cd", fs.dir(args[1]))
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
