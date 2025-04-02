-- https://github.com/endaaman/tym/tree/master
local tym = tym
local theme = require("aquamoon/settings/theme")

tym.set("font", theme.fonts.term_font .. " 12")
tym.set_config({
	shell = "/usr/bin/lush",
	color_foreground = "#" .. theme.fg,
	color_background = "#" .. theme.bg,
	cursor_shape = "ibeam",
	bold_is_bright = true,
	autohide = true,
})

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
tym.set_keymap("<Ctrl>h", function()
	local choice = io.popen("lush -c 'history.lua'"):read()
	if choice then tym.put(choice) end
end)

-- launch a file from the cwd in neovim
-- tym.set_keymap("<Ctrl>d", function() os.execute("lush -c 'nvim_launcher.lua'") end)
