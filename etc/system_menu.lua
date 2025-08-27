package.path = '/home/aqua/.aquamoon/?.lua;/home/aqua/.aquamoon/?/?.lua'
S = require "settings"

local battery_cmd = io.popen("cat /sys/class/power_supply/BAT1/capacity")
local battery = battery_cmd:read("*a")

local date_cmd = io.popen("date '+%I:%M%P on %A, %B %d'")
local date = date_cmd:read("*a")

cmd = "tofi"
for i, arg in ipairs(S.theme.tofi_style) do
	cmd = cmd .. " " .. arg
end

os.execute("$(echo '" .. date ..
	"\nbattery: " .. battery ..
	"\nswaylock --color 232A2E " ..
	"\nriverctl exit' | " .. cmd .. ")")
