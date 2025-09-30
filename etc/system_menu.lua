package.path = '/home/aqua/.aquamoon/?.lua;/home/aqua/.aquamoon/?/?.lua;' ..
    '/home/aqua/.aquamoon/rocks/share/lua/5.1/?.lua;' ..
    '/home/aqua/.aquamoon/rocks/share/lua/5.1/?/?.lua;;'

theme = require "settings".theme

local battery_cmd = io.popen("cat /sys/class/power_supply/BAT1/capacity")
local battery = battery_cmd:read("*a")

local date_cmd = io.popen("date '+%I:%M%P on %A, %B %d'")
local date = date_cmd:read("*a")

cmd = "tofi"
for i, arg in ipairs(theme.tofi_style) do
	cmd = cmd .. " " .. arg
end

os.execute("$(echo '" .. date ..
	"\nbattery: " .. battery ..
	"\ngtklock " ..
	"\nriverctl exit' | " .. cmd .. ")")
