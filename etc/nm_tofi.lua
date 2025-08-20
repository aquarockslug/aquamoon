S = require "settings"
cmd = "networkmanager_dmenu"
default_style = S.theme.tofi_style
-- TODO style = require("table").insert(default_style, "--width=50%")
for i, arg in ipairs(default_style) do
	cmd = cmd .. " " .. arg
end
os.execute(cmd)
