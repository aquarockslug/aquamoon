local S = dofile(os.getenv("HOME") .. "/.aquamoon/settings.lua")

local app = "wlr-randr"

local tofi_style = S.theme.tofi
local menu = dofile(S.path .. "/scripts/tofi.lua").options(tofi_style)
local choices = menu.choices({
	app .. " --output HDMI-A-1 --scale 1.25",
	app .. " --output HDMI-A-1 --scale 1.15",
	app .. " --output HDMI-A-1 --scale 1",
	app .. " --output HDMI-A-1 --scale 0.85",
	app .. " --output HDMI-A-1 --scale 0.75",
})
os.execute(choices.open())
