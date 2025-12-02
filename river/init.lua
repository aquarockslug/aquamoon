package.path = '/home/aqua/.aquamoon/?.lua;/home/aqua/.aquamoon/?/?.lua;;'

os.execute("riverctl input pointer-1739-32183-SYNA7DB5:01_06CB:7DB7_Touchpad tap enabled")

R = require 'river'
S = require 'settings'

R.apply_settings(S)

os.execute("neovide --no-tabs")
