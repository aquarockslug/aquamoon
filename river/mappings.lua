-- River window manager key mappings for Aquamoon
-- Loads keyboard and mouse bindings from TOML configuration

local M = {}

local tinytoml = dofile(os.getenv("HOME") .. "/.aquamoon/scripts/sys/tinytoml.lua")

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

local raw = tinytoml.parse(os.getenv("HOME") .. "/.aquamoon/toml/mappings.toml")

for _, map_type in pairs(raw) do
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

M.map = raw.map
M["map-pointer"] = raw["map-pointer"]

return M
