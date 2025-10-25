package.path = '/home/aqua/.aquamoon/?.lua;/home/aqua/.aquamoon/?/?.lua;' ..
    '/home/aqua/.aquamoon/rocks/share/lua/5.1/?.lua;' ..
    '/home/aqua/.aquamoon/rocks/share/lua/5.1/?/?.lua;;'

-- set up tofi menu
local tofi_style = require("settings").theme.tofi
local menu = require("scripts/tofi").options(tofi_style)

local theme_list = require("settings").theme_list
local cmd = menu.choices(theme_list).open()

-- use sed to replace the current colorscheme name in the rock.toml config file
toml = require "tinytoml"
toml_settings = toml.parse("/home/aqua/.aquamoon/nvim/rocks.toml")
os.execute([[sed -i 's/"]] .. toml_settings.config.colorscheme ..
	[["/"]] .. choice ..
	[["/g' ~/.aquamoon/nvim/rocks.toml]]
)

-- restart river
os.execute("~/.aquamoon/river/init")
