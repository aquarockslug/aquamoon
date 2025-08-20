package.path = '/home/aqua/.aquamoon/?.lua;/home/aqua/.aquamoon/?/?.lua'
return function(theme_name)
	local theme = require("settings/theme").get(theme_name)
	cmd = "tofi-drun"
	for i, arg in ipairs(theme.tofi_style) do
		cmd = cmd .. " " .. arg
	end
	os.execute(cmd)
end
