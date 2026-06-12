-- Master menu hub for Aquamoon
-- Combines all menu functionality into one

local S = dofile(os.getenv("HOME") .. "/.aquamoon/scripts/sys/settings.lua")
local tofi = dofile(S.path .. "/scripts/sys/tofi.lua").opener.options(S.theme.tofi)

local date = io.popen("date '+%I:%M%P on %A, %B %d'"):read("*a")
local battery = io.popen("cat /sys/class/power_supply/BAT0/capacity"):read("*a")
local font = (S.theme.active_font.name:match("^([^:]+)") or S.theme.active_font.name)

local script = function(script_path)
	return "lua " .. S.path .. "/scripts/" .. script_path .. ".lua"
end

local items = {
	date,
	"Battery: " .. battery,
	"Theme: " .. S.theme.name,
	"Font: " .. font,
	"--------------------------------------",
	{ name = "Web Search",  value = script("menu/browse") },
	{ name = "Bookmarks",   value = script("menu/bookmarks") },
	{ name = "Clipboard",   value = script("menu/clipboard") },
	{ name = "Display",     value = script("menu/display") },
	{ name = "Networks",    value = script("menu/networkmanager") },
	{ name = "Screenshot",  value = script("sys/screenshot") },
	{ name = "Eyedropper",  value = script("sys/pick_color") },
	{ name = "Themes",      value = script("theme/theme_picker") },
	{ name = "Screensaver", value = script("daemon/screensaver") },
	{ name = "Bluetooth",   value = "riverctl spawn 'neovide term://bluetui'" },
	{ name = "Git",         value = "riverctl spawn 'neovide +LazyGit'" },
	{ name = "Suspend",     value = "systemctl suspend" },
	{ name = "Reboot",      value = "systemctl reboot" },
	{ name = "Poweroff",    value = "systemctl poweroff" },
	{ name = "Logout",  value = "riverctl exit" },
}

local selection = tofi.choices(items).open()
if selection and selection ~= "" then os.execute(selection) end
