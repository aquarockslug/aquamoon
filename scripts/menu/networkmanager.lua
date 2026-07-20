-- NetworkManager launcher for Aquamoon
-- Opens networkmanager_dmenu for WiFi/Ethernet management

package.path = package.path .. ";" .. os.getenv("HOME") .. "/.aquamoon/?.lua"
local S = require("scripts/sys/settings")
local tofi_style = S.theme.tofi

local cmd = "networkmanager_dmenu"
for setting, value in pairs(tofi_style) do
	cmd = cmd .. " --" .. setting .. "=" .. value
end

os.execute(cmd)
