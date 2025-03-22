-- TODO convert launch.sh into a lua script
local theme = require("aquamoon/theme")

local launch = function()
	local execute
	if lush then
		execute = lush.exec
	else
		execute = os.execute
	end

	execute("tofi-run " ..
		"--font=" .. theme.fonts.iosevka .. " " ..
		"--width=15% " ..
		"--prompt-text=󰈿 " ..
		"--selection-color=#FFFFFF " ..
		"--text-color=#82C092 " ..
		"--border-color=#82C092 " ..
		"--background-color=#272E33 " ..
		"| xargs riverctl spawn"
	)
end
return launch()
