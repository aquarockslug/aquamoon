local theme = require("aquamoon/settings/theme")
local pick = require("aquamoon/scripts/pick")

local cmd = { "tofi-run" }

-- add style arguments to the command
for i = 1, #theme.tofi_style do cmd[i + 1] = theme.tofi_style[i] end

-- pass choice to river spawn
cmd[#theme.tofi_style + 1] = "| xargs riverctl spawn"

-- pass launch arg to run it from the command line
lush.exec(table.concat(cmd, " "))
