-- URL browser launcher for Aquamoon
-- Opens ddgr (DuckDuckGo CLI) in a terminal for web searching

local S = dofile(os.getenv("HOME") .. "/.aquamoon/scripts/sys/settings.lua")
local ddgr_cmd = "ddgr --reverse" .. " --colors " .. S.theme.ddgr_colors

os.execute([[riverctl spawn "neovide term://']] .. ddgr_cmd .. [['"]])
