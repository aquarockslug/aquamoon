-- Combined script to update all theme configurations (dunst, television, lazygit)
-- Rewrites configuration files to match the theme from themes.toml

-- Set up package path for tinytoml and other modules
package.path = '/home/aqua/.aquamoon/?.lua;/home/aqua/.aquamoon/?/?.lua;' ..
    '/home/aqua/.local/share/nvim/rocks/share/lua/5.1/?.lua;' ..
    '/home/aqua/.local/share/nvim/rocks/share/lua/5.1/?/init.lua;;'

local tinytoml = require("tinytoml")

-- Paths to configuration files
local themes_path = "/home/aqua/.aquamoon/themes.toml"
local dunstrc_path = "/home/aqua/.config/dunst/dustrc"
local television_path = "/home/aqua/.config/television/config.toml"
local lazygit_path = "/home/aqua/.config/lazygit/config.yml"

local M = {}

-- Dunst-specific functions
local function read_dunstrc()
	local file = io.open(dunstrc_path, "r")
	if not file then
		return nil, "Could not open dunstrc for reading"
	end

	local content = file:read("*all")
	file:close()
	return content
end

local function write_dunstrc(content)
	local file = io.open(dunstrc_path, "w")
	if not file then
		return false, "Could not open dunstrc for writing"
	end

	file:write(content)
	file:close()
	return true
end

local function update_urgency_section(content, section_name, bg_color, fg_color, frame_color)
	local section_pattern = string.format("(%s.-background = \")#[0-9a-fA-F]+(\")", section_name)
	local fg_pattern = string.format("(%s.-foreground = \")#[0-9a-fA-F]+(\")", section_name)
	local frame_pattern = string.format("(%s.-frame_color = \")#[0-9a-fA-F]+(\")", section_name)

	content = content:gsub(section_pattern, "%1" .. bg_color .. "%2")
	content = content:gsub(fg_pattern, "%1" .. fg_color .. "%2")
	content = content:gsub(frame_pattern, "%1" .. frame_color .. "%2")

	return content
end

-- Television-specific functions
local function generate_toml(data)
	local toml = ""

	toml = toml .. "[ui]\n"
	toml = toml .. string.format('ui_scale = %d\n', data.ui.ui_scale)
	toml = toml .. string.format('orientation = "%s"\n', data.ui.orientation)
	toml = toml .. string.format('theme = "%s"\n', data.ui.theme)
	toml = toml .. "\n"

	for section_name, section_data in pairs(data.ui) do
		if section_name ~= "ui_scale" and section_name ~= "orientation" and section_name ~= "theme" then
			toml = toml .. string.format("[ui.%s]\n", section_name)
			for key, value in pairs(section_data) do
				if type(value) == "string" then
					toml = toml .. string.format('%s = "%s"\n', key, value)
				else
					toml = toml .. string.format('%s = %s\n', key, tostring(value))
				end
			end
			toml = toml .. "\n"
		end
	end

	toml = toml .. "[shell_integration]\n"
	toml = toml .. string.format('fallback_channel = "%s"\n', data.shell_integration.fallback_channel)
	toml = toml .. "\n"

	for section_name, section_data in pairs(data.shell_integration) do
		if section_name ~= "fallback_channel" then
			toml = toml .. string.format("[shell_integration.%s]\n", section_name)
			for key, value in pairs(section_data) do
				if type(value) == "string" then
					toml = toml .. string.format('%s = "%s"\n', key, value)
				elseif type(value) == "table" then
					toml = toml .. string.format('%s = [%s]\n', key, table.concat(value, ", "))
				else
					toml = toml .. string.format('%s = %s\n', key, tostring(value))
				end
			end
			toml = toml .. "\n"
		end
	end

	return toml
end

-- Main update functions
local function update_dunst(theme_name)
	local themes_data = tinytoml.parse(themes_path)
	local theme = themes_data[theme_name]

	if not theme then
		return false, "Theme '" .. theme_name .. "' not found in themes.toml"
	end

	local dunstrc_content, err = read_dunstrc()
	if not dunstrc_content then
		return false, err
	end

	local bg_color = "#" .. theme.bg
	local fg_color = "#" .. theme.fg
	local accent_color = "#" .. theme.accent

	dunstrc_content = update_urgency_section(dunstrc_content, "urgency_low", bg_color, fg_color, fg_color)
	dunstrc_content = update_urgency_section(dunstrc_content, "urgency_normal", bg_color, fg_color, fg_color)
	dunstrc_content = update_urgency_section(dunstrc_content, "urgency_critical", bg_color, fg_color, accent_color)

	local success, write_err = write_dunstrc(dunstrc_content)
	if not success then
		return false, write_err
	end

	return true, "Successfully updated dunstrc"
end

local function update_television(theme_name)
	local themes_data = tinytoml.parse(themes_path)
	local theme = themes_data[theme_name]

	if not theme then
		return false, "Theme '" .. theme_name .. "' not found in themes.toml"
	end

	local television_data = tinytoml.parse(television_path)

	if not television_data then
		return false, "Could not parse television.toml"
	end

	television_data.ui.theme_overrides.background = '#' .. theme.bg
	television_data.ui.theme_overrides.border_fg = '#' .. theme.fg
	television_data.ui.theme_overrides.text_fg = '#' .. theme.fg
	television_data.ui.theme_overrides.dimmed_text_fg = '#' .. theme.fg2
	television_data.ui.theme_overrides.input_text_fg = '#' .. theme.fg
	television_data.ui.theme_overrides.result_count_fg = '#' .. theme.fg
	television_data.ui.theme_overrides.result_name_fg = '#' .. theme.fg
	television_data.ui.theme_overrides.result_line_number_fg = '#' .. theme.accent
	television_data.ui.theme_overrides.result_value_fg = '#' .. theme.fg
	television_data.ui.theme_overrides.selection_fg = '#' .. theme.fg
	television_data.ui.theme_overrides.selection_bg = '#' .. theme.bg
	television_data.ui.theme_overrides.match_fg = '#' .. theme.fg2
	television_data.ui.theme_overrides.preview_title_fg = '#' .. theme.fg
	television_data.ui.theme_overrides.channel_mode_fg = '#' .. theme.bg
	television_data.ui.theme_overrides.channel_mode_bg = '#' .. theme.fg
	television_data.ui.theme_overrides.remote_control_mode_fg = '#' .. theme.bg
	television_data.ui.theme_overrides.remote_control_mode_bg = '#' .. theme.accent

	local file = io.open(television_path, "w")
	if not file then
		return false, "Could not open television.toml for writing"
	end

	file:write(generate_toml(television_data))
	file:close()

	return true, "Successfully updated television.toml"
end

local function update_lazygit(theme_name)
	local themes_data = tinytoml.parse(themes_path)
	local theme = themes_data[theme_name]

	if not theme then
		return false, "Theme '" .. theme_name .. "' not found in themes.toml"
	end

	local yaml = ""

	yaml = yaml .. "\nnotARepository: 'skip'\n\n"
	yaml = yaml .. "gui:\n"
	yaml = yaml .. "  nerdFontsVersion: 3\n\n"
	yaml = yaml .. "  theme:\n"
	yaml = yaml .. string.format("    activeBorderColor:\n      - '#%s'\n", theme.fg)
	yaml = yaml .. "      - bold\n"
	yaml = yaml .. string.format("    inactiveBorderColor:\n      - '#%s'\n", theme.fg2)
	yaml = yaml .. string.format("    optionsTextColor:\n      - '#%s'\n", theme.bg2)
	yaml = yaml .. string.format("    selectedLineBgColor:\n      - '#%s'\n", theme.bg)
	yaml = yaml .. string.format("    cherryPickedCommitBgColor:\n      - '#%s'\n", theme.bg2)
	yaml = yaml .. string.format("    cherryPickedCommitFgColor:\n      - '#%s'\n", theme.accent)
	yaml = yaml .. string.format("    unstagedChangesColor:\n      - '#%s'\n", theme.accent)
	yaml = yaml .. string.format("    defaultFgColor:\n      - '#%s'\n", theme.fg)
	yaml = yaml .. string.format("    searchingActiveBorderColor:\n      - '#%s'\n", theme.fg2)
	yaml = yaml .. "\n  authorColors:\n"
	yaml = yaml .. string.format("    '*': '#%s'\n", theme.fg)

	local file = io.open(lazygit_path, "w")
	if not file then
		return false, "Could not open lazygit.yml for writing"
	end

	file:write(yaml)
	file:close()

	return true, "Successfully updated lazygit.yml"
end

-- Main update function that updates all configurations
M.update_all = function(theme_name)
	if not theme_name then
		return false, "No theme name provided"
	end

	local results = {}
	local overall_success = true

	-- Update dunst
	local success, message = update_dunst(theme_name)
	table.insert(results, { app = "dunst", success = success, message = message })
	if not success then overall_success = false end

	-- Update television
	success, message = update_television(theme_name)
	table.insert(results, { app = "television", success = success, message = message })
	if not success then overall_success = false end

	-- Update lazygit
	success, message = update_lazygit(theme_name)
	table.insert(results, { app = "lazygit", success = success, message = message })
	if not success then overall_success = false end

	return overall_success, results
end

-- Individual update functions
M.update_dunst = function(theme_name)
	return update_dunst(theme_name)
end

M.update_television = function(theme_name)
	return update_television(theme_name)
end

M.update_lazygit = function(theme_name)
	return update_lazygit(theme_name)
end

-- Function to get available themes
M.get_available_themes = function()
	local themes_data = tinytoml.parse(themes_path)
	local themes = {}

	for name, _ in pairs(themes_data) do
		if name ~= "active_font" then
			table.insert(themes, name)
		end
	end

	return themes
end

-- Command line interface
if arg and arg[0] and arg[0]:match("update_configs%.lua$") then
	local theme_name = arg and arg[1]
	local app_name = arg and arg[2] -- optional: update specific app only

	if not theme_name then
		print("Usage: lua update_configs.lua <theme_name> [app_name]")
		print("Available themes:")

		local themes = M.get_available_themes()
		for _, name in ipairs(themes) do
			print("  - " .. name)
		end
		print("\nOptional app_name: dunst, television, lazygit (or omit for all)")
		os.exit(1)
	end

	local success, result
	if app_name then
		-- Update specific app
		if app_name == "dunst" then
			success, result = M.update_dunst(theme_name)
		elseif app_name == "television" then
			success, result = M.update_television(theme_name)
		elseif app_name == "lazygit" then
			success, result = M.update_lazygit(theme_name)
		else
			print("Error: Invalid app_name. Use: dunst, television, lazygit")
			os.exit(1)
		end

		if success then
			print(result)
		else
			print("Error: " .. result)
			os.exit(1)
		end
	else
		-- Update all apps
		success, results = M.update_all(theme_name)

		if success then
			print("Successfully updated all configurations for theme '" .. theme_name .. "':")
			for _, result in ipairs(results) do
				print("  - " .. result.app .. ": " .. result.message)
			end
		else
			print("Some updates failed for theme '" .. theme_name .. "':")
			for _, result in ipairs(results) do
				if result.success then
					print("  - " .. result.app .. ": " .. result.message)
				else
					print("  - " .. result.app .. ": ERROR - " .. result.message)
				end
			end
			os.exit(1)
		end
	end
end

return M

