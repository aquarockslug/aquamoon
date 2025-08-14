M = {}

local themes = {
	"dracula",
	"sweetie",
	-- "desert",
	-- "habamax",
	-- "tokyonight",
	-- "nightfall",
}
-- choose one of the themes based on the current hour
-- M.active_theme = themes[math.ceil(tonumber(os.date("%H")) / 24 * #themes)]
M.active_theme = "sweetie"

M.fonts = {
	bigblue = {
		name = "BigBlueTermPlus Nerd Font Propo:h14",
		path = "'/usr/share/fonts/TTF/BigBlueTermPlusNerdFontMono-Regular.ttf'",
		size = 14
	},
	iosevka = {
		name = "IosevkaTermSlab Nerd Font Mono:h14",
		path = "'/usr/share/fonts/TTF/IosevkaTermSlabNerdFontMono-Regular.ttf'",
		size = 20
	},
	fairiesevka = {
		name = "FairiesevkaTerm Nerd Font Mono:h14",
		path = "'/usr/share/fonts/fairiesevka/FairiesevkaTermNerdFontMono-Regular.ttf'",
		size = 20
	}
}
if M.active_theme == "sweetie" then M.active_font = M.fonts.fairiesevka end
if M.active_theme == "dracula" then M.active_font = M.fonts.bigblue end
M.active_font = M.fonts.fairiesevka

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
	"--font=" .. M.active_font.path,
	"--font-size=" .. M.active_font.size,
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
