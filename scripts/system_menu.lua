require("lib.paths").setup_paths()
require("lib.paths").setup_rocks_paths()

-- get date
local date_cmd = io.popen("date '+%I:%M%P on %A, %B %d'")
local date = date_cmd:read("*a")

-- get battery
local battery_cmd = io.popen("cat /sys/class/power_supply/BAT1/capacity")
local battery = battery_cmd:read("*a")

-- set up tofi menu
local tofi_style = require("settings").theme.tofi
local menu = require("scripts/tofi").options(tofi_style)

-- open
local cmd = menu.choices({
	date ..
	"\nbattery: " .. battery ..
	"\ngtklock " ..
	"\nriverctl exit"
}).open()

os.execute(cmd)
