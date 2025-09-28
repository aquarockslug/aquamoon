-- Lua api for Tofi

-- Usage example:
-- local opener = require("tofi").options({})
-- opener.choices({}).open()

opener = function(choices, options)
	return {
		open = function()
			print(choices)
			print(options)
		end,
		set_choices = function(new_choices)
			return opener(new_choices, options)
		end,
		set_options = function(new_options)
			return opener(choices, new_options)
		end,
	}
end

local new_opener = function()
	local o = opener({}, {})

	return o
end
return new_opener()
