package.path = '/home/aqua/.aquamoon/?.lua;/home/aqua/.aquamoon/?/?.lua'
S = require "settings"

local cmd = "tofi"
for i, arg in ipairs(S.theme.tofi_style) do
	cmd = cmd .. " " .. arg
end

local options = tostring(arg[1])
for i, arg in ipairs(S.theme.list) do
	options = options .. "\n" .. arg
end

-- WARN doesnt work for tofi, use fuzzel?
os.execute(S.path .. "/river/init " ..
	"$(echo '" .. options .. "' | " .. cmd .. ")")
