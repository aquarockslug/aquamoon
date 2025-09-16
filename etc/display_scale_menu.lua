package.path = '/home/aqua/.aquamoon/?.lua;/home/aqua/.aquamoon/?/?.lua;' ..
    '/home/aqua/.aquamoon/rocks/share/lua/5.1/?.lua;' ..
    '/home/aqua/.aquamoon/rocks/share/lua/5.1/?/?.lua;;'

theme = require "settings".theme

cmd = "tofi"
for i, arg in ipairs(theme.tofi_style) do
	cmd = cmd .. " " .. arg
end

os.execute("$(echo '" ..
	"\nwlr-randr --output HDMI-A-1 --scale 1.25" ..
	"\nwlr-randr --output HDMI-A-1 --scale 1.15" ..
	"\nwlr-randr --output HDMI-A-1 --scale 1" ..
	"\nwlr-randr --output HDMI-A-1 --scale 0.85" ..
	"\nwlr-randr --output HDMI-A-1 --scale 0.75" ..
	"' | " .. cmd .. ")")
