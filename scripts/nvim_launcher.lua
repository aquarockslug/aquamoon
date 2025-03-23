local theme = require("aquamoon/settings/theme")
local pick = require("aquamoon/scripts/pick")


local cmd = { "tym", "-c", "nvim", "-c" }

-- options = files in the cwd

-- pick the file or directory to be opened in nvim
local file = pick.with_tofi(options)

-- pass choice to river spawn at the end of the command
cmd[#theme.tofi_style + 1] = "| xargs riverctl spawn"

-- pass launch arg to run it from the command line
lush.exec(table.concat(cmd, " "))
