local direction = arg[1]
local percent_change = 5

if direction == "increase" then
    os.execute("brightnessctl set +" .. percent_change .. "%")
elseif direction == "decrease" then
    os.execute("brightnessctl set " .. percent_change .. "%-")
end

local curr = io.popen("brightnessctl get"):read("*a")
local max = io.popen("brightnessctl max"):read("*a")

package.path = package.path .. ";" .. os.getenv("HOME") .. "/.aquamoon/?.lua"
require("scripts/sys/notify").bar(curr / max * 100, "Brightness")
