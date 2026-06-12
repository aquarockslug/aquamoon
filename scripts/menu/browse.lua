-- URL browser launcher for Aquamoon
-- Opens ddgr (DuckDuckGo CLI) in a terminal for web searching

local S = dofile(os.getenv("HOME") .. "/.aquamoon/scripts/sys/settings.lua")

local theme = "DDGR_COLORS=" .. S.theme.ddgr_colors
local cmd = "'" .. theme .. " neovide term://ddgr'"

os.execute("riverctl spawn " .. cmd)
