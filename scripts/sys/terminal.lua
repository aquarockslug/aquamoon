-- Hilbish terminal emulator configuration for Aquamoon
-- Sets up prompt, aliases, and command bindings

local M = {}

local lunacolors = require 'lunacolors'

local S = dofile(os.getenv("HOME") .. "/.aquamoon/scripts/sys/settings.lua")
local menu = dofile(S.path .. "/scripts/sys/tofi.lua").opener.options(S.theme.tofi)

DDGR_COLORS = S.theme.ddgr_colors
TERM = "neovide"
SHELL = "/bin/hilbish"

hilbish.opts = S.terminal.hilbish_opts
hilbish.appendPath(os.getenv("HOME") .. "/.aquamoon/scripts/")
hilbish.appendPath(os.getenv("HOME") .. "/.cargo/bin/")
hilbish.appendPath(os.getenv("HOME") .. "/.local/bin/")

local function myPrompt()
	local status_color = fail and '{red}' or '{cyan}'
	return lunacolors.format(status_color .. '%d ' .. status_color .. S.terminal.prompt.symbol)
end

hilbish.prompt(myPrompt())

commander.register('cd', function(args, sinks)
	fs.cd(args[1])
	hilbish.prompt(myPrompt())
end)

commander.register('!!', function(args, sinks)
	os.execute("cat ~/.local/share/hilbish/.hilbish-history | tail -n 1")
end)

local ls = S.terminal.aliases.ls
os.execute(ls .. hilbish.cwd())

for i, v in pairs(S.terminal.aliases) do
	hilbish.aliases.add(i, v)
end

return M
