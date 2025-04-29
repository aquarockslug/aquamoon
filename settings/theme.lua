M = {}

M.active_theme = "dracula"
M.my_flag = "󰈿"

M.fonts = {
	iosevka = "/usr/share/fonts/TTF/IosevkaTermSlabNerdFontPropo-ExtraBoldOblique.ttf",
	term_font = "IosevkaTermSlab NFM"
}

M.border_width = 4

-- everforest colors
M.teal = "83C092"
M.blue = "7FBBB3"
M.grey = "272E33"
M.white = "FFFFFF"
M.black = "000000"

-- theme
if M.active_theme == "everforest" then
	M.fg = M.teal
	M.fg2 = M.blue
	M.bg = M.grey
	M.bg2 = M.grey

	-- apps
	M.tofi_style = {
		"--font=" .. M.fonts.iosevka,
		"--width=33%",
		"--outline-width=0",
		"--border-width=" .. M.border_width,
		"--prompt-text=󰈿_",
		"--selection-color=#" .. M.white,
		"--text-color=#" .. M.teal,
		"--border-color=#" .. M.teal,
		"--background-color=#" .. M.grey,
	}
end

return M
