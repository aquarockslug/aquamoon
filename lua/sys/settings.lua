-- Settings loader for the aquamoon2-river branch
--
-- Reads the river/luatile side of the configuration from toml/*.toml.
-- The neovim side of the configuration is the aquamoon2 one and lives in the
-- repository root (init.lua, settings.toml); it is read by neovim itself
-- (with the tinytoml rock below) and is not touched from here.

local M = {}

package.path = package.path .. ";" .. os.getenv("HOME") .. "/.aquamoon/?.lua"

-- The luarocks modules (tinytoml) live in lua_modules/.
require("lua/util/paths")

local TT = require("tinytoml")

local function load(path)
	return TT.parse(os.getenv("HOME") .. "/.aquamoon/" .. path)
end

local config = load("toml/settings.toml")

-- Defaults are the "sweetie" colours used by the aquamoon2 neovim config.
local notify = {
	background = "2a2a3a",
	foreground = "92d3c5",
	accent = "b094e2",
}
for key, value in pairs(config.notify or {}) do
	notify[key] = value
end

M.path = os.getenv("HOME") .. "/.aquamoon"
M.mappings = require("lua/sys/mappings")
M.river_options = config.river_options or {}
M.window_rules = config.window_rules or {}
M.tofi = config.tofi or {}
M.notify = notify
M.startup_commands = load("toml/startup.toml")
M.inputs = load("toml/inputs.toml")

return M
