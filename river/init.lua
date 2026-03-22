-- package.path = '/home/aqua/.aquamoon/?.lua;/home/aqua/.aquamoon/?/?.lua;;'
package.path = "" ..
    os.getenv("HOME") .. "/.aquamoon/?.lua;" ..
    os.getenv("HOME") .. "/.aquamoon/?/?.lua;;"

os.execute("riverctl input pointer-1149-8264-Kensington_Eagle_Trackball pointer-accel 4")
os.execute("pointer-2362-8203-PIXA200B:00_093A:200B_Touchpad pointer-accel 4")

R = require "river"
S = require "settings"

R.apply_settings(S)

require("scripts/write_configs").update_all(S.theme_name)
