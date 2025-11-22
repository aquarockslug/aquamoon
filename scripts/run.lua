require("lib.paths").setup_paths()
require("lib.paths").setup_rocks_paths()

local tofi_style = require("settings").theme.tofi
require("scripts/tofi").options(tofi_style).open()
