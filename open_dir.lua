require("ml").import()
local lfs = require("lfs")
local toml = require("toml_edit")

local settings_file = io.open("settings.toml", "rb"):read("*a")
local settings = toml.parse_as_tbl(settings_file)
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
