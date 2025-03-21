-- NEOVIM CONFIGURATION FOR AQUAMOON

require("aquamoon/rocks_nvim").setup()
T = require("aquamoon/theme")

-- for loop for mini packages
require("snacks").setup( bigfile = { enabled = true } )

if T.active_theme == "everforest" then
	require("everforest").load()
end
