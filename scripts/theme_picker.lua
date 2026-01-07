package.path = '~/.aquamoon/?.lua;/home/aqua/.aquamoon/?/?.lua;' ..
    '~/.aquamoon/rocks/share/lua/5.1/?.lua;' ..
    '~/.aquamoon/rocks/share/lua/5.1/?/?.lua;;'

-- set up tofi menu
local tofi_style = require("settings").theme.tofi
local menu = require("scripts/tofi").options(tofi_style)

local theme_list = require("settings").theme_list
local choice = menu.choices(theme_list).open()

-- use sed to replace the current colorscheme name in the rock.toml config file
local toml_settings = require("tinytoml").parse("/home/aqua/.aquamoon/nvim/rocks.toml")
local cmd = [[sed -i 's/"]] .. toml_settings.config.colorscheme ..
    [["/"]] .. choice ..
    [["/g' ~/.aquamoon/nvim/rocks.toml]]
os.execute(string.gsub(cmd, "\n", "")) -- remove newlines and execute

-- Update theme configurations using the combined script
local success, results = require("scripts/update_configs").update_all(choice)

if not success then
    print("Some theme updates failed:")
    for _, result in ipairs(results) do
        if not result.success then
            print("  - " .. result.app .. ": " .. result.message)
        end
    end
end

-- kill river-luatile so that the init script can restart it with the new settings
os.execute "killall river-luatile"

-- restart river
os.execute "~/.aquamoon/river/init"
