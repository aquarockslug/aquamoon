-- Consolidated mappings loader for River WM and Neovim
-- Loads keyboard and mouse bindings from TOML configuration via tinytoml

local M = {}

local tinytoml = dofile(os.getenv("HOME") .. "/.aquamoon/scripts/sys/tinytoml.lua")

-- River WM mappings -----------------------------------------------------------

local function expand_command(cmd)
	if cmd[1] == "lua-script" then
		local script_name = cmd[2]
		local args_table = {}
		for i = 3, #cmd do args_table[#args_table + 1] = cmd[i] end
		local args = table.concat(args_table, " ")
		local script_path = os.getenv("HOME") .. "/.aquamoon/scripts/"
		return { "spawn", "'sh -c \"lua " .. script_path .. script_name .. ".lua " .. args .. "\"'" }
	elseif cmd[1] == "terminal-app" then
		local app = cmd[2]
		return { "spawn", "'neovide term://\"" .. app .. "\"'" }
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

-- Neovim mappings -------------------------------------------------------------

local raw_nvim = tinytoml.parse(os.getenv("HOME") .. "/.aquamoon/toml/nvim_mappings.toml")

M.oil = raw_nvim.oil and raw_nvim.oil.bindings or {}
M.misc = raw_nvim.misc and raw_nvim.misc.bindings or {}
M.split = raw_nvim.split and raw_nvim.split.bindings or {}
M.leader = raw_nvim.leader or { bindings = {} }
M["function"] = raw_nvim["function"] or { bindings = {} }

return M
