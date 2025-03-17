#!/usr/bin/lua5.4
S = require("settings")

--[[

- execp() needs 'lua-posix' package

--]]

-- Convenient functions ────────────────────────────────────────────────────────

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

-- Apply settings ──────────────────────────────────────────────────────────────

-- Run startup commands
--
-- 'riverctl spawn ...' always returns (even when the child process is a daemon)
-- so we don't need to resort to posix.unistd.spawn()
for _, cmd in ipairs(S.startup_commands) do
	os.execute(string.format([[riverctl spawn '%s']], concat(cmd, " ")))
end

-- Configure outputs
local randr_cmd = "wlr-randr"
for output, options in pairs(S.outputs) do
	randr_cmd = randr_cmd .. " --output " .. output

	for opt, value in pairs(options) do
		if opt ~= "preferred" then
			randr_cmd = string.format(randr_cmd .. " --%s %s", opt, value)
		end
	end

	-- Ensure '--preferred' is the last argument for each monitor
	if options.preferred then
		randr_cmd = randr_cmd .. " --preferred"
	end
end
os.execute(randr_cmd)

-- Configure input devices
for device, options in pairs(S.inputs) do
	for key, val in pairs(options) do
		os.execute(string.format("riverctl input %s %s %s", device, key, val))
	end
end

-- GNOME-related settings
for group, tbl in pairs(S.gsettings) do
	for key, value in pairs(tbl) do
		os.execute(string.format("gsettings set %s %s %s", group, key, value))
	end
end

-- Set river's options
for key, value in pairs(S.river_options) do
	os.execute(string.format("riverctl %s %s", key, concat(value, " ")))
end

-- Additional modes (beside 'normal' and 'locked')
for _, mode in ipairs(S.modes) do
	local mode_name = mode.name
	local modifiers = concat(mode.mod, "+")

	-- Declare the mode
	os.execute("riverctl declare-mode " .. mode_name)

	-- Setup key bindings to enter/exit the mode
	os.execute(string.format("riverctl map normal %s %s enter-mode %s", modifiers, mode.key, mode_name))
	os.execute(string.format("riverctl map %s %s %s enter-mode normal", mode_name, modifiers, mode.key))
end

-- Keyboard and mouse bindings
for map_type, tbl in pairs(S.mappings) do
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

			os.execute(string.format("riverctl %s %s %s %s %s %s", map_type, opt, mode, modifiers, binding.key, cmd))

			-- Duplicate mappings of mode 'locked' for mode 'normal'
			if mode == "locked" then
				os.execute(string.format("riverctl %s %s normal %s %s %s", map_type, opt, modifiers, binding.key, cmd))
			end
		end
	end
end

-- Mappings for tag management
tag_mappings()

-- Window rules (float/csd filters)
for key, value in pairs(S.window_rules) do
	for type, patterns in pairs(value) do
		for _, pattern in ipairs(patterns) do
			os.execute(string.format("riverctl %s %s %s", key, type, pattern))
		end
	end
end

-- Launch the layout generator as the final initial process.
-- River run the init file as a process group leader and send
-- SIGTERM to the group on exit. Therefore, keep the main init
-- process running (replace it with the layout generator process).
local unistd = require("posix.unistd")
unistd.execp("rivertile", {
	"-view-padding",
	5,
	"-outer-padding",
	5,
	"-main-location",
	"left",
	"-main-count",
	1,
	"-main-ratio",
	0.54,
})
