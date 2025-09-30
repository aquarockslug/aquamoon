-- Lua api for Tofi

-- Usage example:
-- local my_opener = require("tofi").options({})
-- my_opener.choices({}).open()

local execute_tofi = function(choices, options)
	local cmd = "tofi"

	-- test data
	local theme = require("settings").theme
	local options = {
		font = theme.active_font.path,
		"font-size" = theme.active_font.path,
		width = "33%",
		height = "66%",
		"drun-launch" = true,
		"outline-width",
		"prompt-text" = "󰈿 ",
		"selection-color" = theme.fg2,
		"border-width" = theme.border_width,
		"text-color" = theme.fg,
		"border-color" .. theme.bg2,
		"background-color" .. theme.bg,
		"text-cursor" = true,
		"result-spacing" = 9,
		anchor = bottom,
		"margin-bottom" = 10,
	}

	for option, value in ipairs(options) do
		-- convert options from { option = "value" } into "--option=value"
		local arg = "--" .. option .. "=" .. value
		cmd = cmd .. " " .. arg
	end
end

opener = function(choi, opts)
	return {
		-- build and execute a tofi command using this opener's parameters
		open = function() execute_tofi(choi, opts) end,

		-- get info about the opener
		info = function()
			return { choices = choi, options = opts }
		end,
		-- return a new opener with the new choices
		choices = function(new_choi)
			return opener(new_choi, opts)
		end,
		-- return a new opener with the new options
		options = function(new_opts)
			return opener(choi, new_opts)
		end,
	}
end

return opener({}, {})
