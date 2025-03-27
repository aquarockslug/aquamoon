-- local pick = require("aquamoon/scripts/pick") WARN require pick runs picker?

local cmd = { "tym", "-u", lush.getenv("HOME") .. "/.aquamoon/terminal.lua", "-e", "\"" .. lush.getenv("EDITOR") .. " " }

-- read from "~/.local/share/nvim/mimi-visits-index"
-- WARN it seems like not all the files are returned
local get_frequent_files = function()
	local mini_visits = require('mini-visits-index')
	local files = {}
	for _, path in pairs(mini_visits) do
		local i = 1
		for file, _ in pairs(path) do
			files[i] = file; i = i + 1
		end
	end
	return files
end

local file
if args then
	-- a file was passed through args
	file = table.concat(args, " ")
else
	-- file = pick.with_tofi(get_frequent_files())
	-- file = string.gsub(file, "\n", "")
	file = "/home/aqua"
end

-- pass launch arg to run it from the command line
if lush.isReadable(file) then
	lush.exec(table.concat(cmd, " ") .. file .. "\"")
else
	lush.exec(table.concat(cmd, " ") .. "\"")
end
