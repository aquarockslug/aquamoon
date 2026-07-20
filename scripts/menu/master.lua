-- Master menu hub for Aquamoon
-- Combines all menu functionality into one

package.path = package.path .. ";" .. os.getenv("HOME") .. "/.aquamoon/?.lua"
local S = require("scripts/sys/settings")
local tofi = require("scripts/sys/tofi").opener.options(S.theme.tofi)

local date = io.popen("date '+%I:%M%P on %A, %B %d'"):read("*a")
local battery = io.popen("cat /sys/class/power_supply/BAT0/capacity"):read("*a")
local font = (S.theme.active_font.name:match("^([^:]+)") or S.theme.active_font.name)

local function script(script_path)
	return "lua " .. S.path .. "/scripts/" .. script_path .. ".lua"
end

local function neovide(cmd)
	return [[riverctl spawn "neovide +']] .. cmd .. [['"]]
end

local items = {
	date,
	"Battery: " .. battery,
	{ name = "Theme: " .. S.theme.name, value = script("theme/theme_picker") },
	{ name = "Font: " .. font,          value = script("theme/theme_picker") },
	"--------------------------------------",
	{ name = "Web Search",    value = script("menu/browse") },
	{ name = "Bookmarks",     value = script("menu/bookmarks") },
	{ name = "Clipboard",     value = script("menu/clipboard") },
	{ name = "Display",       value = script("menu/display") },
	{ name = "Network",       value = script("menu/networkmanager") },
	{ name = "Screenshot",    value = script("util/screenshot") },
	{ name = "Eyedropper",    value = script("util/pick_color") },
	{ name = "System Status", value = script("river/status") },
	{ name = "Screensaver",   value = script("daemon/screensaver") },
	{ name = "Bluetooth",     value = neovide("Term bluetui") },
	{ name = "Packages",      value = neovide("Tv pacman-packages") },
	{ name = "Git",           value = neovide("LazyGit") },
	{ name = "OpenCode",      value = neovide("tab AI") },
	{ name = "Audio",         value = "pavucontrol" },
	{ name = "Suspend",       value = "systemctl suspend" },
	{ name = "Reboot",        value = "systemctl reboot" },
	{ name = "Poweroff",      value = "systemctl poweroff" },
	{ name = "Logout",        value = "riverctl exit" },
}

local selection = tofi.choices(items).open()
if selection and selection ~= "" then os.execute(selection) end
