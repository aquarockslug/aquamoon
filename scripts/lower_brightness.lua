local percent_change = 5
os.execute("brightnessctl set " .. percent_change .. "%-")

local curr = io.popen("brightnessctl get"):read("*a")
local max = io.popen("brightnessctl max"):read("*a")

package.path = '/home/aqua/.aquamoon/?.lua;/home/aqua/.aquamoon/?/?.lua;'
require "scripts/notify".bar(curr / max * 100, "Brightness")
curr_volume:close()
