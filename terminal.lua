-- https://github.com/endaaman/tym/tree/master
local tym = require("tym")

tym.set("width", 100)
tym.set("font", "IosevkaTermSlab NFM 20")
tym.set_config({
	shell = "/usr/bin/lush",
	color_foreground = "#7FBBB3",
	color_background = "#1E2326",
	cursor_shape = "ibeam",
	bold_is_bright = true,
	autohide = true,
})

tym.set_hook("scroll", function(dx, dy, x, y)
	if tym.check_mod_state("<Ctrl>") then
		if dy > 0 then
			s = tym.get("scale") - 10
		else
			s = tym.get("scale") + 10
		end
		tym.set("scale", s)
		tym.notify("set scale: " .. s .. "%")
		return true
	end
end)

-- TODO open current dir in nvim
tym.set_keymap("<Ctrl><Shift>o", function()
	local h = tym.get("height")
	tym.put(h)
end)
