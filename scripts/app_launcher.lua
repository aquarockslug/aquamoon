local theme = require "aquamoon/settings/theme"
local pick = require "aquamoon/scripts/pick"

local cmd = "tofi-run "
local tofi_style = table.concat(theme.tofi_style, " ")
local riverctl_spawn = "| xargs riverctl spawn"

-- pass launch arg to run it from the command line
lush.exec(cmd .. tofi_style .. riverctl_spawn)
