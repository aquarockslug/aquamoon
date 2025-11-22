require("lib.paths").setup_paths()
require("lib.paths").setup_rocks_paths()

cmd = "networkmanager_dmenu"

-- TODO set up tofi menu
-- local tofi_style = require("settings").theme.tofi
-- local menu = require("etc/tofi").options(tofi_style)

-- override the width so this menu is wider than other menus
cmd = cmd .. " --width=50%"

os.execute(cmd)
