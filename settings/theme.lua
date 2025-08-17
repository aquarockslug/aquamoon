M = {}

-- TODO add "desert", "habamax", "tokyonight", "nightfall"
local themes = {
	"dracula",
	"sweetie",
	"rose-pine-moon",
}
-- choose one of the themes based on the current hour
M.active_theme = {
	name = themes[math.ceil(tonumber(os.date("%H")) / 24 * #themes)]
}

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

M.my_flag = "󰈿"
M.active_theme.border_width = 2

-- TODO assign all the colors at once
M.dracula = {
	teal = "83C092",
	blue = "7FBBB3",
	grey = "282A36",
	green = "50FA7B",
}

M.sweetie = {
	teal = "92d3c5",
	blue = "73a3f3",
	grey = "798399",
	dark_grey = "707b87",
	green = "50FA7B",
	bg = "2a2a3a",
	fg = "d3d7de",
}

M.pine = {
	red = "eb6f92",
	moon_bg = "232136",
	moon_fg = "e0def4"
}

-- themes
if M.active_theme.name == "dracula" then
	M.active_font = M.fonts.bigblue
	M.active_theme.fg = M.dracula.green
	M.active_theme.fg2 = M.dracula.green
	M.active_theme.bg = M.dracula.grey
	M.active_theme.bg2 = M.dracula.grey
end
if M.active_theme.name == "sweetie" then
	M.active_font = M.fonts.fairiesevka
	M.active_theme.fg = M.sweetie.teal
	M.active_theme.fg2 = M.sweetie.fg
	M.active_theme.bg = M.sweetie.bg
	M.active_theme.bg2 = M.sweetie.teal
end
if M.active_theme.name == "rose-pine-moon" then
	M.active_font = M.fonts.fairiesevka
	M.active_theme.fg = M.pine.red
	M.active_theme.fg2 = M.pine.moon_fg
	M.active_theme.bg = M.pine.moon_bg
	M.active_theme.bg2 = M.pine.red
end

-- apps
M.tofi_style = {
	"--font=" .. M.active_font.path,
	"--font-size=" .. M.active_font.size,
	"--width=33%",
	"--drun-launch=true",
	"--outline-width=0",
	"--border-width=" .. M.active_theme.border_width,
	"--prompt-text=" .. M.my_flag .. "_",
	"--selection-color=#" .. M.active_theme.fg2,
	"--text-color=#" .. M.active_theme.fg,
	"--border-color=#" .. M.active_theme.bg2,
	"--background-color=#" .. M.active_theme.bg,
	"--text-cursor=true",
	"--result-spacing=9",
	"--anchor=bottom-left",
	"--margin-bottom=26",
	"--margin-left=" .. M.active_theme.border_width,
}


return M
