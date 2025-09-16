package.path = '/home/aqua/.aquamoon/?.lua;/home/aqua/.aquamoon/?/?.lua;' ..
    '/home/aqua/.aquamoon/rocks/share/lua/5.1/?.lua;' ..
    '/home/aqua/.aquamoon/rocks/share/lua/5.1/?/?.lua;;'

local theme_list = {
	"sweetie",
	"moonfly",
	"dracula",
	"minicyan",
	"everviolet",
	"desert",
}

-- create tofi command
local cmd = "tofi"
for i, arg in ipairs(require("settings").theme.tofi_style) do
	cmd = cmd .. " " .. arg
end

-- create options list for tofi
local options = ""
for i, arg in ipairs(theme_list) do
	options = options .. "\n" .. arg
end

-- prompt user to choose a theme with tofi
local choice = io.popen("echo '" .. options .. "' | " .. cmd):read()
print("switching to theme " .. choice)

-- use sed to replace the current colorscheme name in the rock.toml config file
toml = require "tinytoml"
toml_settings = toml.parse("/home/aqua/.aquamoon/nvim/rocks.toml")
os.execute([[sed -i 's/"]] .. toml_settings.config.colorscheme ..
	[["/"]] .. choice ..
	[["/g' ~/.aquamoon/nvim/rocks.toml]]
)

-- restart river
os.execute("~/.aquamoon/river/init")

-- TODO the new river instance is slow?, maybe the old one is still running
