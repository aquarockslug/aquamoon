-- TODO allow this file to be used as a module

S = dofile(os.getenv("HOME") .. "/.aquamoon/settings.lua")
TT = dofile(S.path .. "/etc/tinytoml.lua")

local tofi_style = S.theme.tofi
local menu = dofile(S.path .. "/scripts/tofi.lua").options(tofi_style)

local theme_list = S.theme_list
local choice = menu.choices(theme_list).open()

-- use sed to replace the current colorscheme name in the rock.toml config file
local toml_settings = TT.parse(os.getenv("HOME") .. "/.aquamoon/nvim/rocks.toml")
local cmd = [[sed -i 's/"]] .. toml_settings.config.colorscheme ..
    [["/"]] .. choice ..
    [["/g' ~/.aquamoon/nvim/rocks.toml]]
os.execute(string.gsub(cmd, "\n", "")) -- remove newlines and execute

-- kill river-luatile so that the init script can restart it with the new settings
os.execute "killall river-luatile"

-- restart river
dofile(S.path .. "/river/init.lua")
