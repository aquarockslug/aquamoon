S = require "settings"
cmd = "tofi"
for i, arg in ipairs(S.theme.tofi_style) do
	cmd = cmd .. " " .. arg
end
os.execute("$(echo 'swaylock --color 232A2E\nriverctl exit' | " .. cmd .. ")")
