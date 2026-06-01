-- System menu for Aquamoon
-- Shows date, battery, and provides system actions

local S = dofile(os.getenv("HOME") .. "/.aquamoon/scripts/sys/settings.lua")
local menu = dofile(S.path .. "/scripts/sys/tofi.lua").opener.options(S.theme.tofi)

local date = io.popen("date '+%I:%M%P on %A, %B %d'"):read("*a")
local battery = io.popen("cat /sys/class/power_supply/BAT0/capacity"):read("*a")

os.execute(menu.choices({
	date,
	"Battery: " .. battery,
	"Theme: " .. S.theme.name,
	"Font: " .. (S.theme.active_font.name:match("^([^:]+)") or S.theme.active_font.name),
	"--------------------------------------",
	{ name = "Screenshot",        value = "lua ~/.aquamoon/scripts/sys/screenshot.lua" },
	{ name = "Pick Color",        value = "lua ~/.aquamoon/scripts/sys/pick_color.lua" },
	{ name = "Clipboard History", value = "lua ~/.aquamoon/scripts/menu/clipboard.lua" },
	{ name = "Display Scale",     value = "lua ~/.aquamoon/scripts/menu/display_scale_menu.lua" },
	{ name = "Theme Picker",      value = "lua ~/.aquamoon/scripts/theme/theme_picker.lua" },
	{ name = "Screensaver",       value = "lua ~/.aquamoon/scripts/daemon/screensaver.lua" },
	{ name = "Suspend",           value = "systemctl suspend" },
	{ name = "Reboot",            value = "systemctl reboot" },
	{ name = "Poweroff",          value = "systemctl poweroff" },
	{ name = "Exit River",        value = "riverctl exit" },
}).open())
