package.path = '/home/aqua/.aquamoon/?.lua;/home/aqua/.aquamoon/?/?.lua;' ..
    '/home/aqua/.aquamoon/rocks/share/lua/5.1/?.lua;' ..
    '/home/aqua/.aquamoon/rocks/share/lua/5.1/?/?.lua;;'

-- get tofi style from theme
local tofi_style = require("settings").theme.tofi

local cmd = "networkmanager_dmenu"
for setting, value in pairs(tofi_style) do
	cmd = cmd .. " --" .. setting .. "=" .. value
end

os.execute(cmd)
