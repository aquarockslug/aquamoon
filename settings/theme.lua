M = {}

local fonts = {
	bigblue = {
		name = "BigBlueTermPlus Nerd Font Propo:h16",
		path = "'/usr/share/fonts/TTF/BigBlueTermPlusNerdFontMono-Regular.ttf'",
		size = 16
	},
	fairiesevka = {
		name = "FairiesevkaTerm Nerd Font Mono:h18",
		path = "'/usr/share/fonts/fairiesevka/FairiesevkaTermNerdFontMono-Regular.ttf'",
		size = 18
	}
}

function Dracula()
	local dracula = {
		teal = "83C092",
		blue = "7FBBB3",
		green = "50FA7B",
		fg = "F8F8F2",
		bg = "282A36",
	}
	return {
		active_font = fonts.bigblue,
		fg = dracula.green,
		fg2 = dracula.fg,
		bg = dracula.bg,
		bg2 = dracula.green,
		accent = dracula.green,
		background_image = "/home/aqua/.aquamoon/wallpapers/snow_leopard_green.jpg",
		border_width = 4,
		opacity = 0.33
	}
end

function Sweetie()
	local sweetie = {
		teal = "92d3c5",
		blue = "73a3f3",
		grey = "798399",
		dark_grey = "707b87",
		green = "50FA7B",
		cyan = "0B658E",
		violet = "B094E2",
		bg = "2a2a3a",
		fg = "d3d7de",
		-- bg = "DDDDe7",
		-- fg = "202023",
	}
	return {
		active_font = fonts.fairiesevka,
		fg = sweetie.teal,
		fg2 = sweetie.fg,
		bg = sweetie.bg,
		bg2 = sweetie.teal,
		accent = sweetie.violet,
		background_image = "/home/aqua/.aquamoon/wallpapers/macos_tiger_grey.png",
		border_width = 4,
		opacity = 0.8
	}
end

function OceanicNext()
	local ocean = {
		teal = "5FB3B3",
		blue = "6699CC",
		green = "99C794",
		orange = "F99157",
		purple = "C594C5",
		fg = "D8DEE9",
		bg = "1B2B34",
	}
	return {
		active_font = fonts.bigblue,
		fg = ocean.teal,
		fg2 = ocean.fg,
		bg = ocean.bg,
		bg2 = ocean.teal,
		accent = ocean.orange,
		background_image = "/home/aqua/.aquamoon/wallpapers/mavericks_grey.jpg",
		border_width = 4,
		opacity = 0.8,
	}
end

function Srcery()
	local srcery = {
		red = "EF2F27",
		magenta = "E02C6D",
		black = "1C1B19",
		white = "BAA67F",
	}
	return {
		active_font = fonts.fairiesevka,
		fg = srcery.red,
		fg2 = srcery.white,
		bg = srcery.black,
		bg2 = srcery.red,
		accent = srcery.magenta,
		background_image = "/home/aqua/.aquamoon/wallpapers/flaming-pedals.jpg",
		border_width = 4,
		opacity = 0.8,
	}
end

M.get = function(name)
	M.my_flag = "󰈿"
	local theme = {}
	theme.name = name
	if name == "dracula" then theme = Dracula() end
	if name == "sweetie" then theme = Sweetie() end
	if name == "srcery" then theme = Srcery() end
	if name == "OceanicNext" then theme = OceanicNext() end
	theme.tofi_style = {
		"--font=" .. theme.active_font.path,
		"--font-size=" .. theme.active_font.size,
		"--width=33%",
		"--height=33%",
		"--drun-launch=true",
		"--outline-width=0",
		"--border-width=" .. theme.border_width,
		"--prompt-text='󰈿 '",
		"--selection-color=#" .. theme.fg2,
		"--text-color=#" .. theme.fg,
		"--border-color=#" .. theme.bg2,
		"--background-color=#" .. theme.bg,
		"--text-cursor=true",
		"--result-spacing=9",
		"--anchor=bottom",
		"--margin-bottom=10",
		-- "--margin-bottom=26",
		-- "--margin-left=" .. theme.border_width + 8,
	}
	theme.tofi = {
		font = theme.active_font.path,
		["font-size"] = theme.active_font.size,
		width = "33%",
		height = "33%",
		["drun-launch"] = "true",
		["outline-width"] = 0,
		["prompt-text"] = "󰈿_",
		["selection-color"] = theme.fg2,
		["border-width"] = theme.border_width,
		["text-color"] = theme.fg,
		["border-color"] = theme.bg2,
		["background-color"] = theme.bg,
		["text-cursor"] = "true",
		["result-spacing"] = 9,
		anchor = "bottom",
		["margin-bottom"] = 10
	}
	return theme
end

return M
