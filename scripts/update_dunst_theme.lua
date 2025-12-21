-- re writes the dunstrc file so that it matches the theme from themes.toml

-- Set up package path for tinytoml and other modules
package.path = '/home/aqua/.aquamoon/?.lua;/home/aqua/.aquamoon/?/?.lua;' ..
    '/home/aqua/.local/share/nvim/rocks/share/lua/5.1/?.lua;' ..
    '/home/aqua/.local/share/nvim/rocks/share/lua/5.1/?/init.lua;;'

local tinytoml = require("tinytoml")

-- Paths to configuration files
local themes_path = "/home/aqua/.aquamoon/themes.toml"
local dunstrc_path = "/home/aqua/.aquamoon/etc/dunstrc"

local M = {}

-- Read the current dunstrc file
local function read_dunstrc()
	local file = io.open(dunstrc_path, "r")
	if not file then
		return nil, "Could not open dunstrc for reading"
	end

	local content = file:read("*all")
	file:close()
	return content
end

-- Write the updated dunstrc file
local function write_dunstrc(content)
	local file = io.open(dunstrc_path, "w")
	if not file then
		return false, "Could not open dunstrc for writing"
	end
	
	file:write(content)
	file:close()
	return true
end

-- Update urgency section colors in the dunstrc content
local function update_urgency_section(content, section_name, bg_color, fg_color, frame_color)
	local section_pattern = string.format("(%s.-background = \")#[0-9a-fA-F]+(\")", section_name)
	local fg_pattern = string.format("(%s.-foreground = \")#[0-9a-fA-F]+(\")", section_name)
	local frame_pattern = string.format("(%s.-frame_color = \")#[0-9a-fA-F]+(\")", section_name)

	-- Update background color
	content = content:gsub(section_pattern, "%1" .. bg_color .. "%2")

	-- Update foreground color
	content = content:gsub(fg_pattern, "%1" .. fg_color .. "%2")

	-- Update frame color
	content = content:gsub(frame_pattern, "%1" .. frame_color .. "%2")

	return content
end

-- Main function to update dunstrc theme
M.update = function(theme_name)
	if not theme_name then
		return false, "No theme name provided"
	end

	-- Read the themes.toml file
	local themes_data = tinytoml.parse(themes_path)

	-- Get the requested theme
	local theme = themes_data[theme_name]

	if not theme then
		return false, "Theme '" .. theme_name .. "' not found in themes.toml"
	end

	-- Read the current dunstrc file
	local dunstrc_content, err = read_dunstrc()
	if not dunstrc_content then
		return false, err
	end

	-- Update urgency sections with theme colors
	local bg_color = "#" .. theme.bg
	local fg_color = "#" .. theme.fg
	local accent_color = "#" .. theme.accent

	-- Update low urgency notifications
	dunstrc_content = update_urgency_section(dunstrc_content, "urgency_low", bg_color, fg_color, fg_color)

	-- Update normal urgency notifications
	dunstrc_content = update_urgency_section(dunstrc_content, "urgency_normal", bg_color, fg_color, fg_color)

	-- Update critical urgency notifications (use accent color for frame)
	dunstrc_content = update_urgency_section(dunstrc_content, "urgency_critical", bg_color, fg_color, accent_color)

	-- Write the updated configuration back to dunstrc
	local success, write_err = write_dunstrc(dunstrc_content)
	if not success then
		return false, write_err
	end

	return true, "Successfully updated dunstrc with '" .. theme_name .. "' theme colors"
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

-- Command line interface for standalone usage
if arg and arg[0] and arg[0]:match("update_dunst_theme%.lua$") then
	local theme_name = arg and arg[1]

	if not theme_name then
		print("Usage: lua update_dunst_theme.lua <theme_name>")
		print("Available themes:")

		local themes = M.get_available_themes()
		for _, name in ipairs(themes) do
			print("  - " .. name)
		end
		os.exit(1)
	end

	local success, message = M.update(theme_name)
	if success then
		print(message)
	else
		print("Error: " .. message)
		os.exit(1)
	end
end

return M