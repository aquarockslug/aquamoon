-- River window manager initialization script for Aquamoon
-- Configures inputs, applies settings, and starts background processes

local M = {}

package.path = "" ..
    os.getenv("HOME") .. "/.aquamoon/?.lua;" ..
    os.getenv("HOME") .. "/.aquamoon/?/?.lua;;"

os.execute("riverctl input pointer-1149-8264-Kensington_Eagle_Trackball pointer-accel 4")
os.execute("riverctl input pointer-2362-8203-PIXA200B:00_093A:200B_Touchpad pointer-accel 2")
os.execute(
	"riverctl input pointer-1118-64-Microsoft_Microsoft_3-Button_Mouse_with_IntelliEye\\(TM\\) pointer-accel 3 pointer-accel 4")

local R = require "river"
local S = require "settings"

R.apply_settings(S)
os.execute("swaybg --image " .. S.theme.background_image)

require("scripts/write_configs").update_all(S.theme_name)

return M

