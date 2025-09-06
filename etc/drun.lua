-- TODO avoid having to set path in each script
-- only use one script?

package.path = '/home/aqua/.aquamoon/?.lua;/home/aqua/.aquamoon/?/?.lua;' ..
    '/home/aqua/.aquamoon/rocks/share/lua/5.1/?.lua;' ..
    '/home/aqua/.aquamoon/rocks/share/lua/5.1/?/?.lua;;'

local theme = require("settings").theme

cmd = "tofi-drun"
for i, arg in ipairs(theme.tofi_style) do
	cmd = cmd .. " " .. arg
end

os.execute(cmd)
