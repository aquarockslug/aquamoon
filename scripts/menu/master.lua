-- Master menu hub for Aquamoon
-- Combines all menu functionality into one

local S = dofile(os.getenv("HOME") .. "/.aquamoon/scripts/sys/settings.lua")
local tofi = dofile(S.path .. "/scripts/sys/tofi.lua").opener.options(S.theme.tofi)

local date = io.popen("date '+%I:%M%P on %A, %B %d'"):read("*a")
local battery = io.popen("cat /sys/class/power_supply/BAT0/capacity"):read("*a")
local font = (S.theme.active_font.name:match("^([^:]+)") or S.theme.active_font.name)

-- Run a lua script from the scripts directory
local script = function(script_path)
	return "lua " .. S.path .. "/scripts/" .. script_path .. ".lua"
end

-- Open a new neovide window and run the given nvim command
local neovide = function(cmd)
	return [[riverctl spawn "neovide +']] .. cmd .. [['"]]
end

-- TODO configure this in a toml script?
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
	{ name = "Packages",      value = neovide("Tv pacman-packages") }, -- run tv picker
	{ name = "Git",           value = neovide("LazyGit") },
	{ name = "OpenCode",      value = neovide("tab AI") },      -- run scripts defined by cling.nvim
	{ name = "Audio",         value = "pavucontrol" },          -- TODO replace audio settings interface
	{ name = "Suspend",       value = "systemctl suspend" },
	{ name = "Reboot",        value = "systemctl reboot" },
	{ name = "Poweroff",      value = "systemctl poweroff" },
	{ name = "Logout",        value = "riverctl exit" },
}

local selection = tofi.choices(items).open()
if selection and selection ~= "" then os.execute(selection) end
