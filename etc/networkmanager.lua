package.path = '/home/aqua/.aquamoon/?.lua;/home/aqua/.aquamoon/?/?.lua;' ..
    '/home/aqua/.aquamoon/rocks/share/lua/5.1/?.lua;' ..
    '/home/aqua/.aquamoon/rocks/share/lua/5.1/?/?.lua;;'

cmd = "networkmanager_dmenu"

-- TODO set up tofi menu
-- local tofi_style = require("settings").theme.tofi
-- local menu = require("etc/tofi").options(tofi_style)

-- override the width so this menu is wider than other menus
cmd = cmd .. " --width=50%"

os.execute(cmd)
