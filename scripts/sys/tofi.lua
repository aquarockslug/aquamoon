local M = {}

local function choice_name(choice)
	return type(choice) == "table" and choice.name or choice
end

local function choice_value(choices, name)
	for _, c in ipairs(choices) do
		if choice_name(c) == name then
			if type(c) == "table" then
				return c.value ~= nil and c.value or c.name
			end
			return c
		end
	end
	return name
end

local function execute_tofi(choices, options)
	local cmd = ""
	if choices then
		cmd = "echo '"
		for _, choice in ipairs(choices) do
			cmd = cmd .. choice_name(choice) .. "\n"
		end
		cmd = cmd .. "' | tofi "
	else
		cmd = "tofi-drun "
	end
	for k, v in pairs(options or {}) do
		cmd = cmd .. " --" .. k .. "=" .. v
	end

	local handle = io.popen(cmd)
	local retval = ""
	if handle then
		retval = handle:read("*a")
		handle:close()
	end
	return retval:gsub("%s+$", "")
end

local function create_opener(choices, opts)
	return {
		open = function()
			local selection = execute_tofi(choices, opts)
			if selection == "" then
				return nil
			end
			if choices then
				return choice_value(choices, selection)
			end
			return selection
		end,
		info = function()
			return { choices = choices, options = opts }
		end,
		choices = function(new_choices)
			return create_opener(new_choices, opts)
		end,
		options = function(new_opts)
			return create_opener(choices, new_opts)
		end,
	}
end

M.opener = create_opener(nil, nil)
return M

