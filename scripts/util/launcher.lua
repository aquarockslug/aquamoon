-- Application launcher for the aquamoon2-river branch
--
-- Opens the tofi-drun launcher with the tofi theme of toml/settings.toml.
--
-- tofi-drun only prints the Exec line of the selected desktop entry to
-- stdout by default, and river discards the output of the commands it
-- spawns, so the theme enables drun-launch: the selected application is
-- started by tofi itself.

package.path = package.path .. ";" .. os.getenv("HOME") .. "/.aquamoon/?.lua"

local S = require("scripts/sys/settings")
local tofi = require("scripts/sys/tofi").opener.options(S.tofi)

tofi.open()
