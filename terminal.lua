-- https://github.com/endaaman/tym/tree/master
local tym = tym
local theme = require("aquamoon/settings/theme")

tym.set("font", theme.fonts.term_font .. " 14")
tym.set_config({
	shell = "/usr/bin/lush",
	color_foreground = "#" .. theme.fg,
	color_background = "#" .. theme.bg,
	cursor_shape = "ibeam",
	bold_is_bright = true,
	autohide = true,
	-- color_window_background = "#" .. theme.fg,
	-- padding_top = 2,
	-- padding_bottom = 2,
	-- padding_left = 2,
	-- padding_right = 2,
})

tym.set("title", "󰈿")
tym.set_hook("title", function(t)
	tym.set("title", "󰈿 - " .. t)
	return true
end)

tym.set_hook("scroll", function(dx, dy, x, y)
	if tym.check_mod_state("<Ctrl>") then
		local s
		if dy > 0 then
			s = tym.get("scale") - 5
		else
			s = tym.get("scale") + 5
		end
		tym.set("scale", s)
		tym.notify("set scale: " .. s .. "%")
		return true
	end
end)

-- select from search history
tym.set_keymap("<Ctrl>h", function() tym.put(io.popen("lush -c history.lua"):read()) end)

-- enter filename
tym.set_keymap("<Ctrl>h", function() tym.put(io.popen("lush -c history.lua"):read()) end)
