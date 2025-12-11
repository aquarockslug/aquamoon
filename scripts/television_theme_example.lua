-- Example of how to use the update_television_theme module in river init.lua
-- Add this to your river/init.lua file after the existing setup

-- Load the television theme updater
local tv_theme = require('scripts/update_television_theme')

-- Update television theme to match the current aquamoon theme
local success, message = tv_theme.update(S.theme_name)
if not success then
    print("Warning: " .. message)
end

-- Alternative: You could also update based on time of day
-- local hour = tonumber(os.date("%H"))
-- local theme_name = (hour >= 6 and hour < 18) and "sweetie" or "dracula"
-- tv_theme.update(theme_name)