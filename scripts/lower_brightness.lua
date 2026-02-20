local percent_change = 5
os.execute("brightnessctl set " .. percent_change .. "%-")

local curr = io.popen("brightnessctl get"):read("*a")
local max = io.popen("brightnessctl max"):read("*a")

local S = dofile(os.getenv("HOME") .. "/.aquamoon/settings.lua")
dofile(S.path .. "/scripts/notify.lua").bar(curr / max * 100, "Brightness")
curr_volume:close()
