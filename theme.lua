M = {}

M.active_theme = "everforest"

M.fonts = {
	iosevka = "/usr/share/fonts/TTF/IosevkaTermSlabNerdFontPropo-ExtraBoldOblique.ttf"
}
M.my_flag = "󰈿"

-- everforest colors
M.teal = "83C092"
M.grey = "272E33"

-- apps
M.tofi_style = {
	"--font=" .. M.fonts.iosevka,
	"--width=15%",
	"--prompt-text='󰈿 '",
	"--selection-color=#FFFFFF",
	"--text-color=#82C092",
	"--border-color=#82C092",
	"--background-color=#272E33",
}
-- theme
if M.active_theme == "everforest" then
	M.fg = M.teal
	M.bg = M.grey
	M.bg2 = M.grey
end

return M
