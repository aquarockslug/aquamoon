package.path = '/home/aqua/.aquamoon/?.lua;/home/aqua/.aquamoon/?/?.lua'
return function(theme_name)
	-- TODO add "desert", "habamax", "tokyonight", "nightfall"
	local theme_list = {
		"dracula",
		"sweetie", -- TODO create a light background for this
	}

	local theme = require("settings/theme").get(theme_name)

	local cmd = "tofi"
	for i, arg in ipairs(theme.tofi_style) do
		cmd = cmd .. " " .. arg
	end

	local options = ""
	for i, arg in ipairs(theme_list) do
		options = options .. "\n" .. arg
	end

	-- local path = require("settings").get(theme_name)
	os.execute("/home/aqua/.aquamoon/river/init $(echo '" .. options .. "' | " .. cmd .. ")")

	-- TODO remap neovide and tofi keys to use the updated theme?
	-- local remap_cmd = [[ riverctl Super+D send-layout-cmd luatile 'require("etc/drun")("sweetie")' ]]},
	-- os.execute(remap_cmd)
end
