-- Consolidated mappings loader for the aquamoon2-river branch
-- Loads the river keyboard and mouse bindings from TOML configuration via tinytoml
--
-- Only the river bindings are handled here: the neovim keybindings belong to
-- the aquamoon2 configuration (init.lua) and are not managed by this repo.

local M = {}

package.path = package.path .. ";" .. os.getenv("HOME") .. "/.aquamoon/?.lua"

-- The luarocks modules (tinytoml) live in lua_modules/.
require("scripts/util/paths")

local tinytoml = require("tinytoml")

local function expand_command(cmd)
	if cmd[1] == "lua-script" then
		local script_name = cmd[2]
		local args_table = {}
		for i = 3, #cmd do args_table[#args_table + 1] = cmd[i] end
		local args = table.concat(args_table, " ")
		local script_path = os.getenv("HOME") .. "/.aquamoon/scripts/"
		return { "spawn", "'sh -c \"lua " .. script_path .. script_name .. ".lua " .. args .. "\"'" }
	end
	return cmd
end

local raw_river = tinytoml.parse(os.getenv("HOME") .. "/.aquamoon/toml/mappings.toml")

for _, map_type in pairs(raw_river) do
	for mode, tbl in pairs(map_type) do
		local bindings = tbl.bindings
		for _, binding in ipairs(bindings) do
			if binding.command then
				binding.command = expand_command(binding.command)
			end
		end
		map_type[mode] = bindings
	end
end

M.map = raw_river.map
M["map-pointer"] = raw_river["map-pointer"]

return M
