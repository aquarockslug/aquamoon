-- LOW BATTERY WARNING
-- frequently checks the battery and warns if its too low

local S = dofile(os.getenv("HOME") .. "/.aquamoon/settings.lua")

local threshold = 10      -- the battery level required to trigger the warning
local frequency = 2       -- the amount of times to check in a minute
local low_battery = false -- the state of the battery
local battery_path = "/sys/class/power_supply/BAT1/capacity"

while true do
	local battery = io.popen("cat " .. battery_path)
	local power_left = battery:read("*a")

	if (tonumber(power_left) < threshold and not low_battery) then
		low_battery = true
		dofile(S.path .. "/scripts/notify.lua").send("LOW BATTERY")
	end

	if (tonumber(power_left) >= threshold and low_battery) then
		low_battery = false
	end

	os.execute("sleep " .. 60 / frequency)
end
