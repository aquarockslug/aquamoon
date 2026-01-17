local home = os.getenv("HOME") or "/home/aqua"
package.path = home .. '/.aquamoon/?.lua;' .. home .. '/.aquamoon/?/?.lua;' ..
    home .. '/.aquamoon/rocks/share/lua/5.1/?.lua;' ..
    home .. '/.aquamoon/rocks/share/lua/5.1/?/?.lua;;'

-- get tofi style from theme
local tofi_style = require("settings").theme.tofi

local cmd = "networkmanager_dmenu"
for setting, value in pairs(tofi_style) do
	cmd = cmd .. " --" .. setting .. "=" .. value
end

os.execute(cmd)
