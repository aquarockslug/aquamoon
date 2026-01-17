local home = os.getenv("HOME") or "/home/aqua"
package.path = home .. '/.aquamoon/?.lua;' .. home .. '/.aquamoon/?/?.lua;'

local browser = "qutebrowser"

-- set up tofi menu
local tofi_style = require("settings").theme.tofi
local menu = require("scripts/tofi").options(tofi_style)
local choices = menu.choices({
	"neovide term://ddgr",
	browser .. " itch.io",
	browser .. " github.com",
	browser .. " youtube.com",
	browser .. " 1337x.to",
})
os.execute("riverctl spawn '" .. choices.open() .. "'")
