local S = dofile(os.getenv("HOME") .. "/.aquamoon/settings.lua")

local date_cmd = io.popen("date '+%I:%M%P on %A, %B %d'")
local date = date_cmd:read("*a")

local battery_cmd = io.popen("cat /sys/class/power_supply/BAT1/capacity")
local battery = battery_cmd:read("*a")

local tofi_style = S.theme.tofi
local menu = dofile(S.path .. "/scripts/tofi.lua").options(tofi_style)

-- open
local cmd = menu.choices({
	date ..
	"\nbattery: " .. battery ..
	"\ngtklock " ..
	"\nriverctl exit"
}).open()

os.execute(cmd)
