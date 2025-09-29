-- Lua api for Tofi

-- Usage example:
-- local my_opener = require("tofi").options({})
-- my_opener.choices({}).open()

local execute_tofi = function(choices, options)
	local cmd = "tofi"
	os.execute(cmd)
end

opener = function(choi, opts)
	return {
		-- build and execute a command using this opener's parameters
		open = function()
			execute_tofi()
		end,


		-- these functions return new openers

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
			-- TODO convert new_opts from { option = "value" } into "--option=value"
			return opener(choi, new_opts)
		end,
	}
end

return opener({}, {})
