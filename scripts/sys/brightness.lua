local M = {}

local direction = arg[1]
local percent_change = 5

if direction == "increase" then
    os.execute("brightnessctl set +" .. percent_change .. "%")
elseif direction == "decrease" then
    os.execute("brightnessctl set " .. percent_change .. "%-")
end

local curr = io.popen("brightnessctl get"):read("*a")
local max = io.popen("brightnessctl max"):read("*a")

local S = dofile(os.getenv("HOME") .. "/.aquamoon/settings.lua")
dofile(S.path .. "/scripts/sys/notify.lua").bar(curr / max * 100, "Brightness")

return M
