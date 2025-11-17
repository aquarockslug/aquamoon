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

-- kill river-luatile so that the init script can restart it with the new settings
os.execute "killall river-luatile"

-- restart river
os.execute "~/.aquamoon/river/init"
