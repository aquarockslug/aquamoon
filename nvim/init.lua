-- NEOVIM CONFIGURATION FOR AQUAMOON

-- Theme
require("nvim/rocks_nvim").setup()

T = require("settings/theme")
if T.active_theme == "dracula" then
	require("dracula").setup({ transparent_bg = true, italic_comment = true })
	require("dracula").load({ })
else
	require("everforest").load({ })
end

-- OPTIONS
local vim = vim -- avoid undefined warnings
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
vim.diagnostic.config({ signs = false })
vim.flag = "󰈿"

-- LANGUAGE SERVERS
require("lspconfig")["biome"].setup({})
require("lspconfig")["lua_ls"].setup({})
require("lspconfig")["omnisharp"].setup({ cmd = { "dotnet", "/usr/bin/omnisharp" } })

-- KEYMAP
function Setup_Keymap()
	vim.keymap.set("n", "<leader>/", vim.cmd.noh) -- clear highlighting
	vim.keymap.set("n", "U", "<c-r>")

	-- navigate nvim windows using arrow keys
	vim.keymap.set("n", "<Left>", "<c-w>h")
	vim.keymap.set("n", "<Right>", "<c-w>l")
	vim.keymap.set("n", "<Down>", "<c-w>j")
	vim.keymap.set("n", "<Up>", "<c-w>k")

	-- TODO automatically resize windows?

	local oil = require("oil"); oil.setup({
		keymaps = {
			["q"] = { "actions.close", mode = "n" },
			["h"] = { "actions.parent", mode = "n" },
			["e"] = { "actions.select", mode = "n" },
			-- ["e"] = { "actions.open_external", mode = "n" }, -- TODO open text with nvim in a new terminal
			["l"] = { "actions.select", mode = "n" },
			["zh"] = { "actions.toggle_hidden", mode = "n" },
		},
		watch_for_changes = true
	})

	-- left hand home row
	vim.keymap.set("n", "<leader>g", function() Snacks.picker.grep() end)
	vim.keymap.set("n", "<leader>f", function() Snacks.picker.smart() end)
	vim.keymap.set("n", "<leader>d", function() Snacks.picker.diagnostics() end)
	vim.keymap.set("n", "<leader>s", function() Snacks.picker.lsp_symbols() end)

	-- left hand above row
	vim.keymap.set("n", "<leader>r", vim.lsp.buf.hover)
	vim.keymap.set("n", "<leader>e", function() oil.open(nil, { preview = {} }) end)
	vim.keymap.set("n", "<leader>w", function() Snacks.terminal.toggle() end) -- TODO make foreground color match tym foreground color
	vim.keymap.set("n", "<leader>q", vim.cmd.close)

	-- insert line above or below without going into insert mode
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
	-- TODO add decorations to the terminals?
	terminal = { win = { style = "terminal", position = "float" } },
	lazygit = { win = { position = "float" } },
	indent = {
		animate = { style = "down" },
		chunk = { enabled = true, char = { corner_top = "╭", corner_bottom = "╰" } },
		scope = { enabled = false },
	},
})

Setup_Keymap(); Setup_Autocmd()
