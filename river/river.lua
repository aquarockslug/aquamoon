-- River settings applier for Aquamoon
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
	for _, cmd in pairs(settings.startup_commands) do
		os.execute(string.format([[riverctl spawn '%s']], concat(cmd, " ")))
	end

	for key, value in pairs(settings.river_options) do
		os.execute(string.format("riverctl %s %s", key, concat(value, " ")))
	end

	for map_type, tbl in pairs(settings.mappings) do
		if (map_type == "nvim") then break end
		for mode, value in pairs(tbl) do
			for _, binding in ipairs(value) do
				local modifiers = concat(binding.mod, "+")
				local cmd = concat(binding.command, " ")

				local opt = binding.opt
				if opt ~= "release" and opt ~= "repeat" then
					opt = ""
				else
					opt = "-" .. opt
				end

				os.execute(string.format("riverctl %s %s %s %s %s %s", map_type, opt, mode, modifiers,
					binding.key, cmd))

				if mode == "locked" then
					os.execute(string.format("riverctl %s %s normal %s %s %s", map_type, opt,
						modifiers,
						binding.key, cmd))
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