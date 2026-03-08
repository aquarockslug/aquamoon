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

local myPrompt = function()
	return lunacolors.format(
		'{cyan}%d ' .. (fail and '{red}' or '{cyan}') .. '󰈿 '
	)
end
hilbish.prompt(myPrompt())

hilbish.appendPath("~/.aquamoon/scripts/")

commander.register('cd', function(args, sinks)
	fs.cd(args[1])
	hilbish.prompt(myPrompt())
end)

commander.register('cpanel', function(args, sinks)
	os.execute("ssh -p 21098 -i ~/.ssh/id_rsa aquawwae@68.65.123.84")
end)

local ls = "eza --color --icons -F --hyperlink "
os.execute(ls .. hilbish.cwd())

hilbish.alias("df", "duf")
hilbish.alias("du", "dust")
hilbish.alias("top", "htop")
hilbish.alias("s", "sudo")
hilbish.alias("q", "exit")
hilbish.alias("ls", ls)
hilbish.alias("l", "clear && " .. ls)
hilbish.alias("ll", ls .. " --all")
hilbish.alias("lg", "lazygit")
hilbish.alias("put", "wl-paste")
hilbish.alias("yank", "wl-copy")
hilbish.alias("paru", "paru --bottomup")
hilbish.alias("chmodx", "sudo chmod u+x")
hilbish.alias("ddgr", "ddgr --reverse")
