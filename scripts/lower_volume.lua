jocal amount = 5
os.execute("pamixer --decrease " .. amount)

local curr_volume = io.popen("pamixer --get-volume")

package.path = '/home/aqua/.aquamoon/?.lua;/home/aqua/.aquamoon/?/?.lua;'
require "scripts/notify".bar(curr_volume:read("*a"), "Volume")
curr_volume:close()
