-- Low battery warning daemon for Aquamoon
-- Periodically checks battery level and warns when below threshold

package.path = package.path .. ";" .. os.getenv("HOME") .. "/.aquamoon/?.lua"
local notify = require("scripts/sys/notify")

local threshold = 10
local frequency = 2
local low_battery = false
local battery_path = "/sys/class/power_supply/BAT0/capacity"

while true do
	local battery = io.popen("cat " .. battery_path)
	local power_left = battery:read("*a")

	if (tonumber(power_left) < threshold and not low_battery) then
		low_battery = true
		notify.send("LOW BATTERY")
	end

	if (tonumber(power_left) >= threshold and low_battery) then
		low_battery = false
	end

	os.execute("sleep " .. 60 / frequency)
end
