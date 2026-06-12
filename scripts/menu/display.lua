-- Display menu for Aquamoon
-- Allows selecting display scaling via wlr-randr and color temperature via gammastep

local S = dofile(os.getenv("HOME") .. "/.aquamoon/scripts/sys/settings.lua")

local app = "wlr-randr"
local output = "eDP-1" -- TODO add a output  setting/selection
local temp = function(t)
	return "killall gammastep 2>/dev/null; gammastep -O " .. t
end

local tofi_style = S.theme.tofi
local menu = dofile(S.path .. "/scripts/sys/tofi.lua").opener.options(tofi_style)
local choices = menu.choices({
	{ name = "125%", value = app .. " --output " .. output .. " --scale 1.25" },
	{ name = "115%", value = app .. " --output " .. output .. " --scale 1.15" },
	{ name = "100%", value = app .. " --output " .. output .. " --scale 1" },
	{ name = "85%",  value = app .. " --output " .. output .. " --scale 0.85" },
	{ name = "75%",  value = app .. " --output " .. output .. " --scale 0.75" },
	"--------------------------------------",
	{ name = "Night (3500K)",    value = temp(3500) },
	{ name = "Warm (4500K)",     value = temp(4500) },
	{ name = "Neutral (5500K)",  value = temp(5500) },
	{ name = "Daylight (6500K)", value = temp(6500) },
	{ name = "Off",              value = "killall gammastep 2>/dev/null; gammastep -x" },
})

os.execute(choices.open())
