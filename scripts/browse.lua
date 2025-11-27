require("lib.paths").setup_paths()
require("lib.paths").setup_rocks_paths()

local app = "qutebrowser"

-- set up tofi menu
local tofi_style = require("settings").theme.tofi
local menu = require("scripts/tofi").options(tofi_style)
local choices = menu.choices({
	app .. " itch.io",
	app .. " github.com",
	app .. " youtube.com",
	app .. " 1337x.to",
})
os.execute(choices.open())
