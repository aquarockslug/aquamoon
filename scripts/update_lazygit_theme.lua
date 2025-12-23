-- re writes the lazygit yaml file so that it matches the theme from themes.toml

-- Set up package path for tinytoml and other modules
package.path = '/home/aqua/.aquamoon/?.lua;/home/aqua/.aquamoon/?/?.lua;' ..
    '/home/aqua/.local/share/nvim/rocks/share/lua/5.1/?.lua;' ..
    '/home/aqua/.local/share/nvim/rocks/share/lua/5.1/?/init.lua;;'

local tinytoml = require("tinytoml")

-- Paths to configuration files
local themes_path = "/home/aqua/.aquamoon/themes.toml"
local lazygit_path = "/home/aqua/.aquamoon/etc/lazygit.yml"

local M = {}

-- Main function to update lazygit theme
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

	-- Generate YAML content
	local yaml = ""

	yaml = yaml .. "\nnotARepository: 'skip'\n\n"
	yaml = yaml .. "gui:\n"
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

	-- Write the updated configuration back to lazygit.yml
	local file = io.open(lazygit_path, "w")
	if not file then
		return false, "Could not open lazygit.yml for writing"
	end

	file:write(yaml)
	file:close()

	return true, "Successfully updated lazygit.yml with '" .. theme_name .. "' theme colors"
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
if arg and arg[0] and arg[0]:match("update_lazygit_theme%.lua$") then
	local theme_name = arg and arg[1]

	if not theme_name then
		print("Usage: lua update_lazygit_theme.lua <theme_name>")
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
