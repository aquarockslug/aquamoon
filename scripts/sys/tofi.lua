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
local function create_opener(choices, opts)
	return {
		open = function()
			-- TODO only pass a list of choice.name to tofi
			local selection_name = execute_tofi(choice_names, opts)

			-- TODO look up the value of the choice using its name
			local selection_value = selection_name

			return selection_value
		end,
		info = function()
			return { choices = choices, options = opts }
		end,
		choices = function(new_choices)
			-- TODO choice: { name = "Option On Screen", value = "value returned by code" }

			return create_opener(new_choices, opts)
		end,
		options = function(new_opts)
			return create_opener(choices, new_opts)
		end,
	}
end
opener = create_opener(nil, nil)
M.opener = opener
return M

