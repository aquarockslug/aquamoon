-- package.path = '/home/aqua/.aquamoon/?.lua;/home/aqua/.aquamoon/?/?.lua;;'
package.path = "" ..
    os.getenv("HOME") .. "/.aquamoon/?.lua;" ..
    os.getenv("HOME") .. "/.aquamoon/?/?.lua;;"

os.execute("riverctl input pointer-1739-32183-SYNA7DB5:01_06CB:7DB7_Touchpad tap enabled")

R = require "river"
S = require "settings"

R.apply_settings(S)

-- if S.theme_name == "dracula" then
-- 	os.execute("fish_config theme choose dracula")
-- end

require("scripts/write_configs").update_all(S.theme_name)
