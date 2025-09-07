#!/usr/bin/lua5.4
M = {}

--[[

exports the functions apply_setting and run for starting River window manager

- execp() needs 'lua-posix' package

--]]


-- Wrapper around table.concat() to also handle other types
local function concat(...)
	local list, sep, i, j = ...

	if type(list) == "table" then
		return table.concat(list, sep, i, j)
	else
		return tostring(list)
	end
end

-- These mappings are repeated, so they are separated from the mappings table
local function tag_mappings()
	for i = 1, 9 do
		local tag_num = 1 << (i - 1)

		-- Super+[1-9] to focus tag [0-8]
		os.execute(string.format("riverctl map normal Super %s set-focused-tags %s", i, tag_num))

		-- Super+Shift+[1-9] to tag focused view with tag [0-8]
		os.execute(string.format("riverctl map normal Super+Shift %s set-view-tags %s", i, tag_num))

		-- Super+Control+[1-9] to toggle focus of tag [0-8]
		os.execute(string.format("riverctl map normal Super+Control %s toggle-focused-tags %s", i, tag_num))

		-- Super+Alt+[1-9] to toggle tag [0-8] of focused view
		os.execute(string.format("riverctl map normal Super+Alt %s toggle-view-tags %s", i, tag_num))
	end

	-- river has a total of 32 tags
	local all_tags = (1 << 32) - 1
	os.execute(string.format("riverctl map normal Super 0 set-focused-tags %s", all_tags))
	os.execute(string.format("riverctl map normal Super+Shift 0 set-view-tags %s", all_tags))
end

--- Apply setting by executing riverctl commands
------@param settings table
M.apply_settings = function(settings)
	-- Run startup commands
	for _, cmd in ipairs(settings.startup_commands) do
		os.execute(string.format([[riverctl spawn '%s']], concat(cmd, " ")))
	end

	-- GNOME-related settings
	for group, tbl in pairs(settings.gsettings) do
		for key, value in pairs(tbl) do
			os.execute(string.format("gsettings set %s %s %s", group, key, value))
		end
	end

	-- settingset river's options
	for key, value in pairs(settings.river_options) do
		os.execute(string.format("riverctl %s %s", key, concat(value, " ")))
	end

	-- Keyboard and mouse bindings
	for map_type, tbl in pairs(settings.mappings) do
		for mode, value in pairs(tbl) do
			for _, binding in ipairs(value) do
				local modifiers = concat(binding.mod, "+")
				local cmd = concat(binding.command, " ")

				-- Options -release and -repeat for 'map' and 'unmap' commands
				local opt = binding.opt
				if opt ~= "release" and opt ~= "repeat" then
					opt = ""
				else
					opt = "-" .. opt
				end

				os.execute(string.format("riverctl %s %s %s %s %s %s", map_type, opt, mode, modifiers,
					binding.key, cmd))

				-- Duplicate mappings of mode 'locked' for mode 'normal'
				if mode == "locked" then
					os.execute(string.format("riverctl %s %s normal %s %s %s", map_type, opt,
						modifiers,
						binding.key, cmd))
				end
			end
		end
	end

	-- Mappings for tag management
	tag_mappings()

	-- Window rules (float/csd filters)
	for rule, apps in pairs(settings.window_rules) do
		for _, app in ipairs(apps) do
			os.execute(string.format("riverctl rule-add -app-id %s %s", app, rule))
		end
	end
end

M.run = function()
	-- Launch the layout generator as the final initial process.
	-- River run the init file as a process group leader and send
	-- SIGTERM to the group on exit. Therefore, keep the main init
	-- process running (replace it with the layout generator process).
	local unistd = require("posix.unistd")
	unistd.execp("river-luatile", {})
end
return M
