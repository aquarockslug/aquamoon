local home = os.getenv("HOME") or "/home/aqua"
package.path = home .. '/.aquamoon/?.lua;' .. home .. '/.aquamoon/?/?.lua;' ..
    home .. '/.aquamoon/rocks/share/lua/5.1/?.lua;' ..
    home .. '/.aquamoon/rocks/share/lua/5.1/?/?.lua;;'

local app = "wlr-randr"

-- set up tofi menu
local tofi_style = require("settings").theme.tofi
local menu = require("scripts/tofi").options(tofi_style)
local choices = menu.choices({
	app .. " --output HDMI-A-1 --scale 1.25",
	app .. " --output HDMI-A-1 --scale 1.15",
	app .. " --output HDMI-A-1 --scale 1",
	app .. " --output HDMI-A-1 --scale 0.85",
	app .. " --output HDMI-A-1 --scale 0.75",
})
os.execute(choices.open())
