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
})

tym.set("title", "󰈿")
tym.set_hook("title", function(t)
	tym.set("title", "󰈿" .. t)
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

-- search history
tym.set_keymap("<Ctrl>h", function() tym.put(require("aquamoon/scripts/hist")) end)

-- enter filename
tym.set_keymap("<Ctrl>f", function()
	local ls = io.popen("ls") -- TODO search the cwd
	if not ls then return end
	local files = {}
	for i = 1, 100 do
		files[i] = ls:read("*line")
		if not files[i] then break end
	end
	tym.put(require("aquamoon/scripts/pick").with_tofi(files))
end)
