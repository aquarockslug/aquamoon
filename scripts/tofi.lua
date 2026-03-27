-- Tofi launcher API for Aquamoon
-- Provides a Lua wrapper for the Tofi application launcher

local M = {}

local function execute_tofi(choices, options)
	local cmd = ""
	if choices then
		cmd = "echo '"
		for i, choice in ipairs(choices) do
			cmd = cmd .. choice .. "\n"
		end
		cmd = cmd .. "' | tofi "
	else
		cmd = "tofi-drun "
	end
	for option, value in pairs(options) do
		local arg = "--" .. option .. "=" .. value
		cmd = cmd .. " " .. arg
	end

	local handle = io.popen(cmd)
	local retval = ""
	if handle then retval = handle:read("*a") end
	handle:close()
	return retval
end

local opener
local function create_opener(choi, opts)
	return {
		open = function()
			return execute_tofi(choi, opts)
		end,
		info = function()
			return { choices = choi, options = opts }
		end,
		choices = function(new_choi)
			return create_opener(new_choi, opts)
		end,
		options = function(new_opts)
			return create_opener(choi, new_opts)
		end,
	}
end

opener = create_opener(nil, nil)

M.opener = opener

return M