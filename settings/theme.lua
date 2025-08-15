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
M.active_theme = {
	name = "sweetie"
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
M.dracula = {}
M.dracula.teal = "83C092"
M.dracula.blue = "7FBBB3"
M.dracula.grey = "282A36"
M.dracula.green = "50FA7B"

M.sweetie = {}
M.sweetie.teal = "92d3c5"
M.sweetie.blue = "73a3f3"
M.sweetie.grey = "798399"
M.sweetie.dark_grey = "707b87"
M.sweetie.green = "50FA7B"
M.sweetie.bg = "2a2a3a"
M.sweetie.fg = "d3d7de"

-- theme
if M.active_theme.name == "dracula" then
	M.active_font = M.fonts.bigblue
	M.active_theme.fg = M.dracula.green
	M.active_theme.fg2 = M.dracula.green
	M.active_theme.bg = M.dracula.grey
	M.active_theme.bg2 = M.dracula.grey
end
if M.active_theme.name == "sweetie" then
	M.active_font = M.fonts.fairiesevka
	M.active_theme.fg = M.sweetie.blue
	M.active_theme.fg2 = M.sweetie.fg
	M.active_theme.bg = M.sweetie.bg
	M.active_theme.bg2 = M.sweetie.blue
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
	"--margin-bottom=20",
}


return M
