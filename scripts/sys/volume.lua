local direction = arg[1]
local amount = 5

if direction == "increase" then
    os.execute("pamixer --increase " .. amount)
elseif direction == "decrease" then
    os.execute("pamixer --decrease " .. amount)
end

local curr_volume = io.popen("pamixer --get-volume")

package.path = package.path .. ";" .. os.getenv("HOME") .. "/.aquamoon/?.lua"
require("scripts/sys/notify").bar(curr_volume:read("*a"), "Volume")
curr_volume:close()
