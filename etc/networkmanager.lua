package.path = '/home/aqua/.aquamoon/?.lua;/home/aqua/.aquamoon/?/?.lua;' ..
    '/home/aqua/.aquamoon/rocks/share/lua/5.1/?.lua;' ..
    '/home/aqua/.aquamoon/rocks/share/lua/5.1/?/?.lua;;'

S = require "settings"
cmd = "networkmanager_dmenu"
default_style = S.theme.tofi_style
for i, arg in ipairs(default_style) do
	cmd = cmd .. " " .. arg
end

-- override the width so this menu is wider than other menus
cmd = cmd .. " --width=50%"

os.execute(cmd)
