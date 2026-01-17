local amount = 5
os.execute("pamixer --increase " .. amount)

local curr_volume = io.popen("pamixer --get-volume")

local home = os.getenv("HOME") or "/home/aqua"
package.path = home .. '/.aquamoon/?.lua;' .. home .. '/.aquamoon/?/?.lua;'
require "scripts/notify".bar(curr_volume:read("*a"), "Volume")
curr_volume:close()
