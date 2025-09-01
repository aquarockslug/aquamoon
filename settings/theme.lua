M = {}

-- TODO make seperate files for each theme

-- themes
M.get = function(name)
	local theme = { name = name }
	M.my_flag = "󰈿"

	local dracula = { -- dark theme
		teal = "83C092",
		blue = "7FBBB3",
		green = "50FA7B",
		fg = "F8F8F2",
		bg = "282A36",
	}

	local sweetie = { -- light theme
		teal = "92d3c5",
		blue = "73a3f3",
		grey = "798399",
		dark_grey = "707b87",
		green = "50FA7B",
		-- bg = "2a2a3a",
		-- fg = "d3d7de",
		bg = "DDDDe7",
		fg = "202023",
		cyan = "0B658E",
		violet = "B094E2"
	}

	local fonts = {
		bigblue = {
			name = "BigBlueTermPlus Nerd Font Propo:h14",
			path = "'/usr/share/fonts/TTF/BigBlueTermPlusNerdFontMono-Regular.ttf'",
			size = 14
		},
		fairiesevka = {
			name = "FairiesevkaTerm Nerd Font Mono:h16",
			path = "'/usr/share/fonts/fairiesevka/FairiesevkaTermNerdFontMono-Regular.ttf'",
			size = 20
		}
	}
	if theme.name == "dracula" then
		theme.active_font = fonts.bigblue
		theme.fg = dracula.green
		theme.fg2 = dracula.fg
		theme.bg = dracula.bg
		theme.bg2 = dracula.green
		theme.background_image = "/home/aqua/.aquamoon/snow_leopard_green.jpg"
		theme.border_width = 2
	end
	if theme.name == "sweetie" then
		theme.active_font = fonts.fairiesevka
		theme.fg = sweetie.teal
		theme.fg2 = sweetie.fg
		theme.bg = sweetie.bg
		theme.bg2 = sweetie.teal
		theme.accent = sweetie.violet
		theme.background_image = "/home/aqua/.aquamoon/macos_tiger_grey.png"
		theme.border_width = 2
	end
	theme.tofi_style = {
		"--font=" .. theme.active_font.path,
		"--font-size=" .. theme.active_font.size,
		"--width=33%",
		"--height=50%",
		"--drun-launch=true",
		"--outline-width=0",
		"--border-width=" .. theme.border_width,
		"--prompt-text=" .. M.my_flag .. "__",
		"--selection-color=#" .. theme.fg2,
		"--text-color=#" .. theme.fg,
		"--border-color=#" .. theme.bg2,
		"--background-color=#" .. theme.bg,
		"--text-cursor=true",
		"--result-spacing=9",
		"--anchor=bottom",
		"--margin-bottom=26",
		-- "--margin-left=" .. theme.border_width + 8,
	}
	return theme
end

return M
