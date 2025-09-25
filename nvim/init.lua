-- NEOVIM CONFIGURATION FOR AQUAMOON
package.path = '/home/aqua/.aquamoon/?.lua;/home/aqua/.aquamoon/?/?.lua;' ..
    '/home/aqua/.aquamoon/rocks/share/lua/5.1/?.lua;' ..
    '/home/aqua/.aquamoon/rocks/share/lua/5.1/?/?.lua;;'
local settings = require "settings"
local vim = vim -- avoid undefined warnings
require "nvim/rocks_setup"

vim.g.mapleader = ","
vim.g.maplocalleader = ","
vim.flag = "󰈿"

-- LANGUAGE SERVERS
require("lspconfig")["biome"].setup({})
require("lspconfig")["lua_ls"].setup({})
require("lspconfig")["vale_ls"].setup({})
require("lspconfig")["gdscript"].setup({})

-- SNIPE
require("snipe").setup({
	ui = {
		position = "center",
		text_align = "file-first",
		open_win_override = {
			title = vim.flag,
			border = "rounded"
		}
	},
	navigate = { open_vsplit = "e", open_split = "E" }
})


-- OIL
-- Declare a global function to retrieve the current directory
function _G.get_oil_winbar()
	local bufnr = vim.api.nvim_win_get_buf(vim.g.statusline_winid)
	local dir = require("oil").get_current_dir(bufnr)
	if dir then
		return " " .. vim.flag .. " " .. vim.fn.fnamemodify(dir, ":~")
	else
		return " " .. vim.flag .. " " .. vim.api.nvim_buf_get_name(0)
	end
end

require("oil").setup({
	watch_for_changes = true,
	use_default_keymaps = false,
	keymaps = {
		["H"] = { "actions.parent", mode = "n" },
		["L"] = { "actions.select", mode = "n" },
		["e"] = { "actions.select", opts = { close = false, vertical = true }, mode = "n" },
		["E"] = { "actions.select", opts = { close = false, horizontal = true }, mode = "n" },
		["<Tab>"] = { "actions.preview", mode = "n" }, -- TODO shows an error on image preview

		-- "z" is like the <leader> for Oil
		["zo"] = { "actions.open_external", mode = "n" },
		["zy"] = { "actions.yank_entry", mode = "n" },
		["zz"] = { "actions.open_terminal", mode = "n" },
		["zh"] = { "actions.toggle_hidden", mode = "n" },
	},
	columns = {
		"icon",
		"size"
	},
	-- TODO winbar is the wrong color on some themes
	-- win_options = {
	-- 	winbar = "%!v:lua.get_oil_winbar()",
	-- },
})

-- MINI
for _, plug in ipairs({
	"ai",
	"basics",
	"bracketed",
	"comment",
	"completion",
	"diff",
	"icons",
	"jump",
	"jump2d",
	"pairs",
	"snippets",
	"starter",
	"surround",
	"trailspace",
	"visits",
	"indentscope",
}) do
	require("mini." .. plug).setup()
end
require("mini.indentscope").setup({ symbol = vim.flag, draw = { delay = 300 } }) -- │
require("mini.snippets").setup({ mappings = { jump_next = "<Tab>", jump_prev = "<S-Tab>" } })
require("mini.hipatterns").setup({
	highlighters = {
		WARN = { pattern = "%f[%w]()WARN()%f[%W]", group = "MiniHipatternsWarn" },
		HACK = { pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHipatternsHack" },
		TODO = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
	},
})

-- DIAGNOSTICS
vim.diagnostic.config({
	signs = false,
	virtual_lines = true
})
vim.diagnostic.disable()
vim.diagnostic_count = function()
	print(vim.diagnostic.count(nil, { severity = { min = vim.diagnostic.severity.WARN } })[2])
end

-- require the other aquamoon nvim config files
require "nvim/autocmds"; require "nvim/keymap"

-- COLORS
vim.cmd.highlight("LineNr guibg=#" .. settings.theme.bg)
vim.cmd.highlight("LineNr guifg=#" .. settings.theme.fg)
vim.cmd.highlight("LineNrAbove guifg=#" .. settings.theme.fg)
vim.cmd.highlight("LineNrBelow guifg=#" .. settings.theme.fg)
vim.cmd.highlight("CursorLineNr guifg=#" .. settings.theme.fg)
vim.cmd.highlight("OilDir guifg=#" .. settings.theme.fg)

vim.g.oceanic_next_terminal_bold = 1
vim.g.oceanic_next_terminal_italic = 1

-- NEOVIDE
if vim.g.neovide then
	vim.g.neovide_opacity = settings.theme.opacity
	vim.o.guifont = settings.theme.active_font.name
	vim.g.neovide_text_gamma = 0.8
	vim.g.neovide_text_contrast = 0.1
	vim.g.neovide_padding_left = 10
	vim.g.neovide_padding_top = 10
	vim.g.neovide_cursor_vfx_mode = "torpedo"
end

vim.cmd.Oil()
