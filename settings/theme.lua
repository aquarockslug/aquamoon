M = {}

-- TODO make seperate files for each theme

-- themes
M.get = function(name)
	local theme = { name = name }
	M.my_flag = "󰈿"

	M.dracula = {
		teal = "83C092",
		blue = "7FBBB3",
		green = "50FA7B",
		fg = "F8F8F2",
		bg = "282A36",
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

	local fonts = {
		bigblue = {
			name = "BigBlueTermPlus Nerd Font Propo:h14",
			path = "'/usr/share/fonts/TTF/BigBlueTermPlusNerdFontMono-Regular.ttf'",
			size = 14
		},
		fairiesevka = {
			name = "FairiesevkaTerm Nerd Font Mono:h14",
			path = "'/usr/share/fonts/fairiesevka/FairiesevkaTermNerdFontMono-Regular.ttf'",
			size = 20
		}
	}
	if theme.name == "rose-pine-moon" then
		theme.active_font = fonts.fairiesevka
		theme.fg = M.pine.red
		theme.fg2 = M.pine.moon_fg
		theme.bg = M.pine.moon_bg
		theme.bg2 = M.pine.red
		theme.background_image = "/home/aqua/.aquamoon/macos_tiger_grey.png"
		theme.border_width = 2
	end
	if theme.name == "dracula" then
		theme.active_font = fonts.bigblue
		theme.fg = M.dracula.green
		theme.fg2 = M.dracula.fg
		theme.bg = M.dracula.bg
		theme.bg2 = M.dracula.green
		theme.background_image = "/home/aqua/.aquamoon/snow_leopard_green.jpg"
		theme.border_width = 2
	end
	if theme.name == "sweetie" then
		theme.active_font = fonts.fairiesevka
		theme.fg = M.sweetie.teal
		theme.fg2 = M.sweetie.fg
		theme.bg = M.sweetie.bg
		theme.bg2 = M.sweetie.teal
		theme.background_image = "/home/aqua/.aquamoon/macos_tiger_grey.png"
		theme.border_width = 2
	end
	theme.tofi_style = {
		"--font=" .. theme.active_font.path,
		"--font-size=" .. theme.active_font.size,
		"--width=33%",
		"--drun-launch=true",
		"--outline-width=0",
		"--border-width=" .. theme.border_width,
		"--prompt-text=" .. M.my_flag .. "_",
		"--selection-color=#" .. theme.fg2,
		"--text-color=#" .. theme.fg,
		"--border-color=#" .. theme.bg2,
		"--background-color=#" .. theme.bg,
		"--text-cursor=true",
		"--result-spacing=9",
		"--anchor=bottom-left",
		"--margin-bottom=26",
		"--margin-left=" .. theme.border_width,
	}
	return theme
end

return M
