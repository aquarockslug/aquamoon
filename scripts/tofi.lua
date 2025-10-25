-- Lua api for Tofi

-- Usage example:
-- local my_opener = require("tofi").options({})
-- my_opener.choices({}).open()

local execute_tofi = function(choices, options)
	local cmd = ""
	if choices then
		-- build the choices string
		cmd = "echo '"
		for i, choice in ipairs(choices) do
			cmd = cmd .. choice .. "\n"
		end
		cmd = cmd .. "' | tofi "
	else
		cmd = "tofi-drun "
	end
	for option, value in pairs(options) do
		-- convert options from { option = "value" } into "--option=value"
		local arg = "--" .. option .. "=" .. value
		-- add the argument to the command
		cmd = cmd .. " " .. arg
	end

	-- execute the command
	local handle = io.popen(cmd)
	local retval = ""
	if handle then retval = handle:read("*a") end
	handle:close()
	return retval
end

opener = function(choi, opts)
	return {
		-- build and execute a tofi command using this opener's parameters
		open = function()
			return execute_tofi(choi, opts)
		end,

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

return opener(nil, nil)
