S = require "settings"
cmd = "tofi-drun"
for i, arg in ipairs(S.theme.tofi_style) do
	cmd = cmd .. " " .. arg
end
os.execute(cmd)
