package.path = '/home/aqua/.aquamoon/?.lua;/home/aqua/.aquamoon/?/?.lua'
return function(theme_name)
	-- TODO add "desert", "habamax", "tokyonight", "nightfall"
	local theme_list = {
		"dracula",
		"sweetie", -- TODO create a light background for this
		"rose-pine-moon",
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

	os.execute(require("settings").path .. "/river/init " ..
		"$(echo '" .. options .. "' | " .. cmd .. ")")
end
