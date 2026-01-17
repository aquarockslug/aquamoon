-- TODO avoid having to set path in each script
local home = os.getenv("HOME") or "/home/aqua"
package.path = home .. '/.aquamoon/?.lua;' .. home .. '/.aquamoon/?/?.lua;' ..
    home .. '/.aquamoon/rocks/share/lua/5.1/?.lua;' ..
    home .. '/.aquamoon/rocks/share/lua/5.1/?/?.lua;;'

require("scripts/tofi")
    .options(require("settings").theme.tofi)
    .open()
