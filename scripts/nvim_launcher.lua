local pick = require("aquamoon/scripts/pick")

local cmd = { "tym", "-u", lush.getenv("HOME") .. "/.aquamoon/terminal.lua", "-e", "\"" .. lush.getenv("EDITOR") .. " " }

-- read from "~/.local/share/nvim/mimi-visits-index"
local get_frequent_files = function()
	local mini_visits = require('mini-visits-index')[lush.getenv("HOME")]
	local files = {}
	local i = 1
	for file, _ in pairs(mini_visits) do
		files[i] = file; i = i + 1
	end
	return files
end

local file
if args then
	-- a file was passed through args
	file = table.concat(args, " ")
else
	-- pick from recent files
	file = pick.with_tofi(get_frequent_files())
	file = string.gsub(file, "\n", "")
end

-- pass launch arg to run it from the command line
if lush.isReadable(file) or lush.isDir(file) then
	lush.exec(table.concat(cmd, " ") .. file .. "\"")
else
	lush.exec(table.concat(cmd, " ") .. "\"")
end
