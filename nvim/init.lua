-- NEOVIM CONFIGURATION FOR AQUAMOON
package.path = '/home/aqua/.aquamoon/?.lua;/home/aqua/.aquamoon/?/?.lua'
local settings = require "settings"
local theme = settings.theme
local vim = vim -- avoid undefined warnings

-- TODO remove Snacks dependency

vim.g.mapleader = ","
vim.g.maplocalleader = ","
vim.opt.clipboard = "unnamedplus" -- allows neovim to access the system clipboard
vim.opt.autochdir = true
vim.opt.cmdheight = 0
vim.opt.laststatus = 1
vim.opt.number = true
vim.opt.numberwidth = 3
-- vim.opt.relativenumber = true
vim.opt.scrolloff = 10000
vim.opt.signcolumn = "no"
vim.opt.showtabline = 0
vim.diagnostic.config({
	signs = false,
	virtual_lines = true
})
vim.flag = "󰈿"

require("nvim/rocks_nvim").setup()

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

-- NEOVIDE
if vim.g.neovide then
	vim.g.neovide_opacity = 0.5
	vim.o.guifont = settings.theme.active_font.name
	vim.g.neovide_text_gamma = 0.8
	vim.g.neovide_text_contrast = 0.1
	vim.g.neovide_padding_left = 10
	vim.g.neovide_padding_top = 10
	-- vim.g.neovide_cursor_vfx_mode = "torpedo"
end

-- LANGUAGE SERVERS
require("lspconfig")["biome"].setup({})
require("lspconfig")["omnisharp"].setup({ cmd = { "dotnet", "/usr/bin/omnisharp" } })
require("lspconfig")["lua_ls"].setup({})
require("lspconfig")["vale_ls"].setup({})
require("lspconfig")["gdscript"].setup({})
-- vim.lsp.enable('gdscript')

require("debugprint").setup() -- g?p and g?v

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

-- OIL
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
		["zw"] = { "actions.open_terminal", mode = "n" },
		["zh"] = { "actions.toggle_hidden", mode = "n" },
	},
	columns = {
		"icon",
		"size"
	},
	-- TODO winbar is the wrong color
	win_options = {
		-- winbar = "%!v:lua.get_oil_winbar()",
	},
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
	-- "tabline"
}) do
	require("mini." .. plug).setup()
end
require("mini.indentscope").setup({ symbol = vim.flag, draw = { delay = 300 } }) -- │
require("mini.snippets").setup({ mappings = { jump_next = "<Tab>", jump_prev = "<S-Tab>" } })

-- SNACKS
-- TODO turn off autocomplete when snacks picker is open
-- TODO make snacks picker fullscreen
require("snacks").setup({
	bigfile = { enabled = true },
	notifier = { enabled = true },
	quickfile = { enabled = true },
	scroll = { enabled = true },
	image = { enabled = true },
	lazygit = { win = { position = "float" } },
	styles = {
		terminal = { height = 0.999, width = 0.999, position = "top", backdrop = false },
		notification = { border = "top" }
	}
})


-- DIAGNOSTICS
Snacks.toggle.diagnostics():set(false)
require("trouble").setup({
	auto_close = true,
	auto_refresh = true,
	focus = true,
	win = { position = "right" },
	icons = {
		indent = {
			middle = " ",
			last = " ",
			top = " ",
			ws = "│  ",
		},
	},
	modes = {
		diagnostics = {
			groups = {
				{ "filename", format = "{file_icon} {basename:Title} {count}" },
			},
		},
	},
})

vim.diagnostic_count = function()
	print(vim.diagnostic.count(nil, { severity = { min = vim.diagnostic.severity.WARN } })[2])
end

-- COLORSCHEME
vim.cmd.colorscheme(settings.theme.name)
require "nvim/autocmds"; require "nvim/keymap"
require("mini.hipatterns").setup({
	highlighters = {
		WARN = { pattern = "%f[%w]()WARN()%f[%W]", group = "MiniHipatternsWarn" },
		HACK = { pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHipatternsHack" },
		TODO = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
	},
})
vim.cmd.highlight("MiniHipatternsHack", "guifg=LineNr")
vim.cmd.highlight("MiniHipatternsWarn", "guifg=LineNr")
vim.cmd.highlight("MiniHipatternsTodo", "guifg=LineNr")
vim.cmd.highlight("LineNr guibg=#" .. settings.theme.bg)
vim.cmd.highlight("LineNr guifg=#" .. settings.theme.fg)
vim.cmd.highlight("LineNrAbove guifg=#" .. settings.theme.fg)
vim.cmd.highlight("LineNrBelow guifg=#" .. settings.theme.fg)
vim.cmd.highlight("CursorLineNr guifg=#" .. settings.theme.fg)

vim.cmd.highlight("OilDir guifg=#" .. settings.theme.fg)
vim.cmd.Oil()
