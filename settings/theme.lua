local rocks_path = "/home/aqua/.local/share/nvim/rocks/share/lua/5.1/?.lua;"
rocks_path = rocks_path .. "/home/aqua/.local/share/nvim/rocks/share/lua/5.1/?/init.lua;"
local rocks_cpath = "/home/aqua/.local/share/nvim/rocks/lib/lua/5.1/?.so;"
rocks_cpath = rocks_cpath .. "/home/aqua/.local/share/nvim/rocks/lib64/lua/5.1/?.so;"
local aquamoon_path = '/home/aqua/.aquamoon/?.lua;/home/aqua/.aquamoon/?/?.lua;'
package.path = package.path .. rocks_path .. aquamoon_path .. ";"
package.cpath = package.cpath .. rocks_cpath .. ";"

M = {}

local read_toml = function(theme_data_path)
	return require("tinytoml").parse(theme_data_path)
end

M.get = function(name)
	M.my_flag = "󰈿"
	local toml = read_toml "/home/aqua/.aquamoon/themes.toml"
	local theme = toml[name]
	theme.name = name
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
