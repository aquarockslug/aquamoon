-- NEOVIM CONFIGURATION FOR AQUAMOON

-- Theme
require("aquamoon/editor/rocks_nvim").setup()
T = require("aquamoon/settings/theme")
if T.active_theme == "everforest" then require("everforest").load() end

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

-- KEYMAP
function Setup_Keymap()
	vim.keymap.set("n", "<leader>/", vim.cmd.noh) -- clear highlighting
	vim.keymap.set("n", "U", "<c-r>")

	vim.keymap.set("n", "<leader>d", vim.lsp.buf.hover)
	vim.keymap.set("n", "<leader>e", MiniFiles.open)

	vim.keymap.set("n", "<leader>j", Snacks.picker.jumps)
	vim.keymap.set("n", "<leader>u", Snacks.picker.undo)

	-- insert line above or below without going into insert mode
	vim.keymap.set("n", "gO", "<Cmd>call append(line('.') - 1, repeat([''], v:count1))<CR>")
	vim.keymap.set("n", "go", "<Cmd>call append(line('.'),     repeat([''], v:count1))<CR>")
end

for cmd, func in pairs({
	[1] = function() Snacks.lazygit.open() end,
	[2] = function()
		vim.notify(vim.flag .. " formatting...", vim.log.levels.INFO)
		vim.lsp.buf.format()
		vim.cmd.write()
	end,
}) do
	vim.keymap.set("i", "<F" .. cmd .. ">", func)
	vim.keymap.set("n", "<F" .. cmd .. ">", func)
end

-- AUTOCOMMANDS
function Setup_Autocmd()
	vim.api.nvim_create_autocmd("BufWritePost", {
		callback = function()
			MiniTrailspace.trim()
			vim.notify(vim.flag .. " wrote " .. vim.fn.expand("%:p"), vim.log.levels.INFO)
		end,
	})
	vim.api.nvim_create_autocmd("InsertEnter", {
		callback = function() Snacks.toggle.option("cursorline"):set(true) end,
	})
	vim.api.nvim_create_autocmd("InsertLeave", {
		callback = function() Snacks.toggle.option("cursorline"):set(false) end,
	})
	vim.api.nvim_create_autocmd("TextYankPost", {
		callback = function() vim.highlight.on_yank({ higroup = "DiffAdd", timeout = 250 }) end,
	})
end

-- MINI
for _, plug in ipairs({ -- mini plug to load later using their default config
	"snippets",
	"icons",
	"completion",
	"starter",
	"basics",
	"comment",
	"diff",
	"visits",
	"jump",
	"jump2d",
	"bracketed",
	"ai",
	"pairs",
	"surround",
	"trailspace",
	"files", -- TODO use netrw or snacks explorer instead?
}) do
	require("mini." .. plug).setup()
end
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
	indent = {
		animate = { style = "down" },
		chunk = { enabled = true, char = { corner_top = "╭", corner_bottom = "╰" } },
		scope = { enabled = false },
	},
})
Setup_Keymap(); Setup_Autocmd()
