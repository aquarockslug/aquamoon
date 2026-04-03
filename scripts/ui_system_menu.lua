-- System menu for Aquamoon
-- Shows date, battery, and provides system actions (screensaver, lock, exit)

local M = {}

local S = dofile(os.getenv("HOME") .. "/.aquamoon/settings.lua")

local date_cmd = io.popen("date '+%I:%M%P on %A, %B %d'")
local date = date_cmd:read("*a")

local battery_cmd = io.popen("cat /sys/class/power_supply/BAT0/capacity")
local battery = battery_cmd:read("*a")

local menu = dofile(S.path .. "/scripts/sys_tofi.lua").opener
menu = menu.options(S.theme.tofi)

local cmd = menu.choices({
	date ..
	"\nbattery: " .. battery ..
	"\ntheme: " .. S.theme.name ..
	"\nlua ~/.aquamoon/scripts/theme_screensaver.lua " ..
	"\ngtklock " ..
	"\nriverctl exit"
}).open()

os.execute(cmd)

return M

