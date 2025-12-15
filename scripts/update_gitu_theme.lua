-- Set up package path for tinytoml and other modules
package.path = '/home/aqua/.aquamoon/?.lua;/home/aqua/.aquamoon/?/?.lua;' ..
    '/home/aqua/.local/share/nvim/rocks/share/lua/5.1/?.lua;' ..
    '/home/aqua/.local/share/nvim/rocks/share/lua/5.1/?/init.lua;;'

local tinytoml = require("tinytoml")

-- Paths to configuration files
local themes_path = "/home/aqua/.aquamoon/themes.toml"
local gitu_path = "/home/aqua/.aquamoon/etc/gitu.toml"

local M = {}

-- Generate the updated TOML content
local function generate_toml(data)
    local toml = ""
    
    -- General section
    toml = toml .. "[general]\n"
    toml = toml .. string.format('always_show_help.enabled = %s\n', tostring(data.general.always_show_help.enabled))
    toml = toml .. string.format('mouse_support = %s\n', tostring(data.general.mouse_support))
    toml = toml .. string.format('confirm_discard = "%s"\n', data.general.confirm_discard)
    toml = toml .. "\n"
    
    -- Style section
    toml = toml .. "[style]\n"
    toml = toml .. string.format('section_header = { fg = "%s", mods = "%s" }\n', data.style.section_header.fg, data.style.section_header.mods)
    toml = toml .. string.format('file_header = { fg = "%s" }\n', data.style.file_header.fg)
    toml = toml .. string.format('syntax_highlight.keyword = { fg = "%s" }\n', data.style.syntax_highlight.keyword.fg)
    toml = toml .. string.format('hash = { fg = "%s" }\n', data.style.hash.fg)
    toml = toml .. string.format('tag = { fg = "%s" }\n', data.style.tag.fg)
    toml = toml .. string.format('cursor = { symbol = "%s", fg = "%s" }\n', data.style.cursor.symbol, data.style.cursor.fg)
    toml = toml .. string.format('selection_bar = { symbol = "%s", fg = "%s", mods = "%s" }\n', data.style.selection_bar.symbol, data.style.selection_bar.fg, data.style.selection_bar.mods)
    toml = toml .. string.format('selection_line = { mods = "%s" }\n', data.style.selection_line.mods)
    toml = toml .. string.format('selection_area = {}\n')
    
    return toml
end

-- Main function to update gitu theme
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
    
    -- Read the current gitu.toml file
    local gitu_data = tinytoml.parse(gitu_path)
    
    if not gitu_data then
        return false, "Could not parse gitu.toml"
    end
    
    -- Update the style colors with the selected theme colors
    gitu_data.style.section_header.fg = '#' .. theme.fg
    gitu_data.style.file_header.fg = '#' .. theme.accent
    gitu_data.style.syntax_highlight.keyword.fg = '#' .. theme.accent
    gitu_data.style.hash.fg = '#' .. theme.accent
    gitu_data.style.tag.fg = '#' .. theme.accent
    gitu_data.style.cursor.fg = '#' .. theme.fg
    gitu_data.style.selection_bar.fg = '#' .. theme.fg2
    gitu_data.style.selection_line.mods = "BOLD"
    
    -- Write the updated configuration back to gitu.toml
    local file = io.open(gitu_path, "w")
    if not file then
        return false, "Could not open gitu.toml for writing"
    end
    
    file:write(generate_toml(gitu_data))
    file:close()
    
    return true, "Successfully updated gitu.toml with '" .. theme_name .. "' theme colors"
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
if arg and arg[0] and arg[0]:match("update_gitu_theme%.lua$") then
    local theme_name = arg and arg[1]
    
    if not theme_name then
        print("Usage: lua update_gitu_theme.lua <theme_name>")
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