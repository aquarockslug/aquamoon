-- Hilbish terminal emulator configuration for Aquamoon
-- Sets up prompt, aliases, and command bindings

local M = {}

local lunacolors = require 'lunacolors'

local S = dofile(os.getenv("HOME") .. "/.aquamoon/settings.lua")
local menu = dofile(S.path .. "/scripts/sys_tofi.lua").opener.options(S.theme.tofi)

DDGR_COLORS = S.theme.ddgr_colors

hilbish.opts = S.terminal.hilbish_opts
hilbish.appendPath("~/.aquamoon/scripts/")
hilbish.appendPath("~/.cargo/bin/")

local function myPrompt()
	local status_color = fail and '{red}' or '{cyan}'
	return lunacolors.format(status_color .. '%d ' .. status_color .. S.terminal.prompt.flag)
end

hilbish.prompt(myPrompt())

commander.register('cd', function(args, sinks)
	fs.cd(args[1])
	hilbish.prompt(myPrompt())
end)

commander.register('h', function(args, sinks)
	local histFile = os.getenv("HOME") .. "/.local/share/hilbish/.hilbish-history"
	local handle = io.popen("tac " .. histFile)
	local history = {}
	if handle then
		for line in handle:lines() do
			table.insert(history, line)
		end
		handle:close()
	end

	local choice = menu.choices(history).open()
	if choice and choice ~= "" then
		hilbish.editor:insert(choice)
	end
end)

commander.register('!!', function(args, sinks)
	os.execute("cat ~/.local/share/hilbish/.hilbish-history | tail -n 1")
end)

commander.register('cpanel', function(args, sinks)
	os.execute("ssh -p 21098 -i ~/.ssh/id_rsa aquawwae@68.65.123.84")
end)

local ls = S.terminal.aliases.ls
os.execute(ls .. hilbish.cwd())

for i, v in pairs(S.terminal.aliases) do
	hilbish.aliases.add(i, v)
end

return M

