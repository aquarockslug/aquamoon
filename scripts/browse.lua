local S = dofile(os.getenv("HOME") .. "/.aquamoon/settings.lua")

local theme = "DDGR_COLORS=" .. S.theme.ddgr_colors
local cmd = "'" .. theme .. " neovide term://ddgr'"

os.execute("riverctl spawn " .. cmd)
