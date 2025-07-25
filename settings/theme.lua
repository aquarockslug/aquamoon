M = {}

M.active_theme = "dracula"
M.fonts = {
	iosevka = "'IosevkaTermSlab NFP'",
	bigblue = "'BigBlueTermPlus Nerd Font Propo'",
	bigblue_path = "'/usr/share/fonts/TTF/BigBlueTermPlusNerdFontPropo-Regular.ttf'"
}

M.my_flag = "󰈿"
M.border_width = 2

M.teal = "83C092"
M.blue = "7FBBB3"
M.grey = "282A36"
M.white = "FFFFFF"
M.black = "000000"
M.green = "50FA7B"

-- theme
M.fg = M.green
M.fg2 = M.green
M.bg = M.grey
M.bg2 = M.grey

-- apps
M.tofi_style = {
	"--font=" .. M.fonts.bigblue_path,
	"--font-size=14",
	"--width=33%",
	"--drun-launch=true",
	"--outline-width=0",
	"--border-width=" .. M.border_width,
	"--prompt-text=󰈿_",
	"--selection-color=#" .. M.white,
	"--text-color=#" .. M.fg,
	"--border-color=#" .. M.fg,
	"--background-color=#" .. M.bg,
	"--text-cursor=true",
	"--result-spacing=9",
	"--anchor=bottom-left",
	"--margin-bottom=20",
}

return M
