-- URL browser launcher for Aquamoon
-- Opens ddgr (DuckDuckGo CLI) in a terminal for web searching

package.path = package.path .. ";" .. os.getenv("HOME") .. "/.aquamoon/?.lua"
local S = require("scripts/sys/settings")
local ddgr_cmd = "ddgr --reverse" .. " --colors " .. S.theme.ddgr_colors

os.execute([[riverctl spawn "neovide term://']] .. ddgr_cmd .. [['"]])
