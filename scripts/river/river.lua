-- River settings applier for the aquamoon2-river branch
-- Applies configuration, mappings, and window rules to River

local M = {}

local function concat(...)
	local list, sep, i, j = ...

	if type(list) == "table" then
		return table.concat(list, sep, i, j)
	else
		return tostring(list)
	end
end

local function tag_mappings()
	for i = 1, 9 do
		local tag_num = 1 << (i - 1)

		os.execute(string.format("riverctl map normal Super %s set-focused-tags %s", i, tag_num))
		os.execute(string.format("riverctl map normal Super+Shift %s set-view-tags %s", i, tag_num))
		os.execute(string.format("riverctl map normal Super+Control %s toggle-focused-tags %s", i, tag_num))
		os.execute(string.format("riverctl map normal Super+Alt %s toggle-view-tags %s", i, tag_num))
	end

	local all_tags = (1 << 32) - 1
	os.execute(string.format("riverctl map normal Super 0 set-focused-tags %s", all_tags))
	os.execute(string.format("riverctl map normal Super+Shift 0 set-view-tags %s", all_tags))
end

M.apply_settings = function(settings)
	for _, input in pairs(settings.inputs) do
		for key, value in pairs(input) do
			if key ~= "device" then
				local cmd = string.format("riverctl input %s %s %s", input.device, key, tostring(value))
				os.execute(cmd)
			end
		end
	end

	for _, cmd in pairs(settings.startup_commands) do
		os.execute(string.format([[riverctl spawn '%s']], concat(cmd, " ")))
	end

	for key, value in pairs(settings.river_options) do
		os.execute(string.format("riverctl %s %s", key, concat(value, " ")))
	end

	for map_type, tbl in pairs(settings.mappings) do
		for mode, value in pairs(tbl) do
			for _, binding in ipairs(value) do
				local cmd = concat(binding.command, " ")

				local opt = binding.opt
				if opt ~= "release" and opt ~= "repeat" then opt = "" else opt = "-" .. opt end

				-- Bindings without modifiers (e.g. the XF86 media keys) need
				-- river's "None" modifier, the argument cannot be omitted.
				local modifiers
				if binding.mod and #binding.mod > 0 then
					modifiers = concat(binding.mod, "+")
				else
					modifiers = "None"
				end

				local function bind(map_mode)
					os.execute(string.format("riverctl %s %s %s %s %s %s", map_type, opt, map_mode,
						modifiers, binding.key, cmd))
				end

				bind(mode)

				if mode == "locked" then
					bind("normal")
				end
			end
		end
	end

	tag_mappings()

	for rule, apps in pairs(settings.window_rules) do
		for _, app in ipairs(apps) do
			os.execute(string.format("riverctl rule-add -app-id %s %s", app, rule))
		end
	end
end

return M
