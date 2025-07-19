S = require "settings"
cmd = "networkmanager_dmenu"
for i, arg in ipairs(S.theme.tofi_style) do
	cmd = cmd .. " " .. arg
end
os.execute(cmd)
