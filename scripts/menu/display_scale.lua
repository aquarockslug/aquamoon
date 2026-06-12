-- Display scale menu for Aquamoon
-- Allows selecting display scaling via wlr-randr

local S = dofile(os.getenv("HOME") .. "/.aquamoon/scripts/sys/settings.lua")

local app = "wlr-randr"
local display = "eDP-1"

local tofi_style = S.theme.tofi
local menu = dofile(S.path .. "/scripts/sys/tofi.lua").opener.options(tofi_style)
local choices = menu.choices({
	app .. " --output " .. display .. " --scale 1.25",
	app .. " --output " .. display .. " --scale 1.15",
	app .. " --output " .. display .. " --scale 1",
	app .. " --output " .. display .. " --scale 0.85",
	app .. " --output " .. display .. " --scale 0.75",
})
os.execute(choices.open())
