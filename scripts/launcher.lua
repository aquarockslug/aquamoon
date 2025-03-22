local theme = require("aquamoon/theme")

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
local launch = function()
	local execute
	if lush then
		execute = lush.exec
	else
		execute = os.execute
	end
	execute(table.concat(cmd, " "))
end

if arg and arg[1] == "launch" then launch() end
return launch
