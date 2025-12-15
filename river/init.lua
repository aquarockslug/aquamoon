package.path = '/home/aqua/.aquamoon/?.lua;/home/aqua/.aquamoon/?/?.lua;;'

os.execute("riverctl input pointer-1739-32183-SYNA7DB5:01_06CB:7DB7_Touchpad tap enabled")

R = require 'river'
S = require 'settings'

R.apply_settings(S)

-- Use the theme updater scripts
local tv_theme = require('scripts/update_television_theme')
local gitu_theme = require('scripts/update_gitu_theme')

local success, message = tv_theme.update(S.theme_name)
if not success then
	print("Warning: " .. message)
end
local success, message = gitu_theme.update(S.theme_name)
if not success then
	print("Warning: " .. message)
end
