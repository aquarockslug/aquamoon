local theme = require("aquamoon/settings/theme")

local cmd = {
	"tofi-run",
	theme.tofi_style[1],
	theme.tofi_style[2],
	theme.tofi_style[3],
	theme.tofi_style[4],
	theme.tofi_style[5],
	theme.tofi_style[6],
	theme.tofi_style[7],
	"| xargs riverctl spawn",
}

-- pass launch arg to run it from the command line
lush.exec(table.concat(cmd, " "))
