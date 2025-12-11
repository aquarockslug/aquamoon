-- Set up package path for tinytoml and other modules
package.path = '/home/aqua/.aquamoon/?.lua;/home/aqua/.aquamoon/?/?.lua;' ..
    '/home/aqua/.local/share/nvim/rocks/share/lua/5.1/?.lua;' ..
    '/home/aqua/.local/share/nvim/rocks/share/lua/5.1/?/init.lua;;'

local tinytoml = require("tinytoml")

-- Paths to configuration files
local themes_path = "/home/aqua/.aquamoon/themes.toml"
local television_path = "/home/aqua/.aquamoon/etc/television.toml"

local M = {}

-- Generate the updated TOML content
local function generate_toml(data)
    local toml = ""
    
    -- UI section
    toml = toml .. "[ui]\n"
    toml = toml .. string.format('ui_scale = %d\n', data.ui.ui_scale)
    toml = toml .. string.format('orientation = "%s"\n', data.ui.orientation)
    toml = toml .. string.format('theme = "%s"\n', data.ui.theme)
    toml = toml .. "\n"
    
    -- UI subsections
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
    
    -- Shell integration section
    toml = toml .. "[shell_integration]\n"
    toml = toml .. string.format('fallback_channel = "%s"\n', data.shell_integration.fallback_channel)
    toml = toml .. "\n"
    
    -- Shell integration subsections
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

-- Main function to update television theme
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
    
    -- Read the current television.toml file
    local television_data = tinytoml.parse(television_path)
    
    if not television_data then
        return false, "Could not parse television.toml"
    end
    
    -- Update the theme overrides with the selected theme colors
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
    
    -- Write the updated configuration back to television.toml
    local file = io.open(television_path, "w")
    if not file then
        return false, "Could not open television.toml for writing"
    end
    
    file:write(generate_toml(television_data))
    file:close()
    
    return true, "Successfully updated television.toml with '" .. theme_name .. "' theme colors"
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
if arg and arg[0] and arg[0]:match("update_television_theme%.lua$") then
    local theme_name = arg and arg[1]
    
    if not theme_name then
        print("Usage: lua update_television_theme.lua <theme_name>")
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