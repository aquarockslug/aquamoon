local tofi_style = require("settings").theme.tofi
local menu = require("etc/tofi").options(tofi_style)

local choices = { "a", "b", "c" }
print(menu.choices(choices).open())
