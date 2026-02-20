local S = dofile(os.getenv("HOME") .. "/.aquamoon/settings.lua")

local browser = "qutebrowser"

local tofi_style = S.theme.tofi
local menu = dofile(S.path .. "/scripts/tofi.lua").options(tofi_style)
local choices = menu.choices({
	"neovide term://ddgr",
	browser .. " itch.io",
	browser .. " github.com",
	browser .. " youtube.com",
	browser .. " 1337x.to",
})
os.execute("riverctl spawn '" .. choices.open() .. "'")
