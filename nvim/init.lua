-- NEOVIM CONFIGURATION FOR AQUAMOON

require("nvim/rocks_nvim").setup()

-- OPTIONS
local vim = vim -- avoid undefined warnings

-- THEME
require("dracula").setup({ italic_comment = true, transparent_bg = true })
local currenthour = tonumber(os.date("%H"))
if currenthour >= 12 and currenthour <= 20 then
	-- vim.cmd [[colorscheme everforest]]
	vim.cmd [[colorscheme desert]]
else
	vim.cmd [[colorscheme dracula]]
end

vim.g.mapleader = ","
vim.g.maplocalleader = ","
vim.opt.clipboard = "unnamedplus" -- allows neovim to access the system clipboard
vim.opt.autochdir = true
vim.opt.cmdheight = 0
vim.opt.laststatus = 1
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.scrolloff = 10000
vim.opt.signcolumn = "no"
vim.diagnostic.config({
	signs = false,
	virtual_lines = true
})
vim.flag = "󰈿"

-- LANGUAGE SERVERS
require("lspconfig")["biome"].setup({})
require("lspconfig")["lua_ls"].setup({})
require("lspconfig")["omnisharp"].setup({ cmd = { "dotnet", "/usr/bin/omnisharp" } })

require("oil").setup({
	keymaps = {
		["q"] = { "actions.close", mode = "n" },
		["h"] = { "actions.parent", mode = "n" },
		["l"] = { "actions.select", mode = "n" },
		["e"] = { "actions.select", opts = { close = false, vertical = true }, mode = "n" },
		["zh"] = { "actions.toggle_hidden", mode = "n" },
		["<Tab>"] = { "actions.preview", mode = "n" },
	},
	watch_for_changes = true,
})

-- KEYMAP
function Setup_Keymap()
	vim.keymap.set("n", "<leader>/", vim.cmd.noh) -- clear highlighting
	vim.keymap.set("n", "U", "<c-r>")

	-- navigate nvim windows using arrow keys
	vim.keymap.set("n", "<Left>", "<c-w>h")
	vim.keymap.set("n", "<Right>", "<c-w>l")
	vim.keymap.set("n", "<Down>", "<c-w>j")
	vim.keymap.set("n", "<Up>", "<c-w>k")


	-- left hand home row
	vim.keymap.set("n", "<leader>g", function() Snacks.picker.grep() end)
	vim.keymap.set("n", "<leader>f", function() Snacks.picker.smart() end)
	vim.keymap.set("n", "<leader>d", function() Snacks.picker.diagnostics() end)
	vim.keymap.set("n", "<leader>D", function() require("trouble").open({ mode = "diagnostics" }) end)
	vim.keymap.set("n", "<leader>s", function() Snacks.picker.spelling() end)
	vim.keymap.set("n", "<leader>S", function() Snacks.picker.lsp_symbols() end)

	-- left hand top row
	vim.keymap.set("n", "<leader>r", vim.lsp.buf.hover)
	vim.keymap.set("n", "<leader>e", function() require("oil").open() end)
	vim.keymap.set("n", "<leader>w", function() Snacks.terminal.toggle() end) -- TODO make foreground color match the theme
	vim.keymap.set("n", "<leader>q", vim.cmd.close)

	-- right hand
	vim.keymap.set("n", "<leader>m", function() Snacks.picker() end)

	-- insert line above or below without going into insert mode
	-- TODO use the built-in keybinds [<Space> and ]<Space> instead
	vim.keymap.set("n", "gO", "<Cmd>call append(line('.') - 1, repeat([''], v:count1))<CR>")
	vim.keymap.set("n", "go", "<Cmd>call append(line('.'),     repeat([''], v:count1))<CR>")

	for cmd, func in pairs({
		[1] = function() Snacks.lazygit.open() end,
		[2] = function()
			MiniTrailspace.trim()
			vim.lsp.buf.format()
			vim.cmd.write()
		end,
		[3] = vim.cmd.bnext,
		[4] = vim.cmd.bprev
	}) do
		vim.keymap.set("i", "<F" .. cmd .. ">", func)
		vim.keymap.set("n", "<F" .. cmd .. ">", func)
	end
end

-- AUTOCOMMANDS
function Setup_Autocmd()
	vim.api.nvim_create_autocmd("InsertEnter", {
		callback = function() Snacks.toggle.option("cursorline"):set(true) end,
	})
	vim.api.nvim_create_autocmd("InsertLeave", {
		callback = function() Snacks.toggle.option("cursorline"):set(false) end,
	})
	vim.api.nvim_create_autocmd("TextYankPost", {
		callback = function() vim.highlight.on_yank({ higroup = "DiffAdd", timeout = 250 }) end, -- TODO use a different highlight group?
	})
end

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
}) do
	require("mini." .. plug).setup()
end

require("mini.snippets").setup({ mappings = { jump_next = "<Tab>", jump_prev = "<S-Tab>" } })

require("mini.hipatterns").setup({
	highlighters = {
		WARN = { pattern = "%f[%w]()WARN()%f[%W]", group = "MiniHipatternsWarn" },
		HACK = { pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHipatternsHack" },
		TODO = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
	},
})

-- SNACKS
require("snacks").setup({
	bigfile = { enabled = true },
	notifier = { enabled = true },
	quickfile = { enabled = true },
	scroll = { enabled = true },
	image = { enabled = true },
	-- TODO add decorations to the terminals?
	terminal = { win = { style = "terminal", position = "float" } },
	lazygit = { win = { position = "float" } },
	indent = {
		animate = { style = "down" },
		chunk = { enabled = true, char = { corner_top = "╭", corner_bottom = "╰" } },
		scope = { enabled = false },
	},
})

-- DIAGNOSTICS
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

Setup_Keymap(); Setup_Autocmd()
