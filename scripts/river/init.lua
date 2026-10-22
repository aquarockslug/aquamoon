-- River session init for the aquamoon2-river branch
-- Applies the river/luatile configuration and starts the background services
--
-- Startup flow:
--   ~/.config/river/init (bash) -> init.lua -> settings.lua -> riverctl
--
-- The neovim configuration is the aquamoon2 one (repository root) and is
-- started by river through the keybindings in toml/mappings.toml.

package.path = package.path .. ";" .. os.getenv("HOME") .. "/.aquamoon/?.lua"

local R = require("scripts/river/river")
local S = require("scripts/sys/settings")

R.apply_settings(S)
