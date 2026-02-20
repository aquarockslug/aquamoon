local S = dofile(os.getenv("HOME") .. "/.aquamoon/settings.lua")

local tofi_style = S.theme.tofi

local cmd = "networkmanager_dmenu"
for setting, value in pairs(tofi_style) do
	cmd = cmd .. " --" .. setting .. "=" .. value
end

os.execute(cmd)
