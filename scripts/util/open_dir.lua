-- Project picker for the aquamoon2 configuration.
--
-- Lists the directories of the project path (projects.toml) in a tofi window
-- and opens the selected one in neovide.
--
-- Run it from anywhere:
--
--   lua ~/.aquamoon/scripts/util/open_dir.lua

local source = debug.getinfo(1, "S").source:sub(2) -- strip the leading "@"
local script_dir = source:match("^(.*)[/\\][^/\\]*$") or "."
local repo = script_dir .. "/../.."

-- The repository modules and the luarocks modules (lfs, tofi, tinytoml) live
-- in the repository.
package.path = package.path .. ";" .. repo .. "/?.lua"
require("scripts.util.paths")

local lfs = require("lfs")
local settings = require("tinytoml").parse(repo .. "/projects.toml")
local tofi = require("tofi").options(settings.tofi)

local path = settings["project-path"]

local paths = {}
local choices = {}
for file in lfs.dir(path) do
	if file ~= "." and file ~= ".." then
		local full_path = path .. "/" .. file
		local is_dir = "directory" == lfs.attributes(full_path).mode
		if is_dir then
			paths[file] = full_path
			table.insert(choices, file)
		end
	end
end
local choice = tofi.choices(choices).open()
local dir = paths[choice]

-- print(tstring(settings))

-- Prefer the user-local neovide (0.13-compatible nightly) over the system one.
-- The repo neovide (0.16.2) cannot parse nvim 0.13 API metadata.
local neovide = os.getenv("NEOVIDE_BIN")
if not neovide then
	local local_bin = os.getenv("HOME") .. "/.local/bin/neovide"
	if io.open(local_bin, "r") then
		neovide = local_bin
	else
		neovide = "neovide"
	end
end

local appname = "aquamoon2"
os.execute("env NVIM_APPNAME=" .. appname .. " foot -- " .. neovide .. " --fork --frame none " .. dir)
-- TODO: start a server that serves the files in dir
-- TODO: open localhost in a browser
