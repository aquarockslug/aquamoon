-- AQUA ARCH NEOVIM
-- The main nvim configuration file
local vim = vim -- avoid undefined var warning

local Plug = vim.fn["plug#"]
-- vim.call("plug#begin", "~/aqua_arch/aqua_nvim/plugged")
vim.call("plug#begin", "/usr/share/nvim_plugged")
Plug("echasnovski/mini.ai") -- va
Plug("echasnovski/mini.animate")
Plug("echasnovski/mini.bufremove")
Plug("echasnovski/mini.comment") -- gc
Plug("echasnovski/mini.icons")
Plug("echasnovski/mini.indentscope")
Plug("echasnovski/mini.jump")
Plug("echasnovski/mini.notify")
Plug("echasnovski/mini.pairs")
Plug("echasnovski/mini.splitjoin") -- gS
Plug("echasnovski/mini.surround") -- sa
Plug("echasnovski/mini.tabline")
Plug("echasnovski/mini.trailspace")

Plug("L3MON4D3/LuaSnip")
Plug("Mofiqul/dracula.nvim", { as = "dracula" })
Plug("MunifTanjim/nui.nvim")
Plug("NvChad/nvim-colorizer.lua")
Plug("ThePrimeagen/vim-be-good")
Plug("akinsho/toggleterm.nvim")
Plug("ellisonleao/glow.nvim")
Plug("eoh-bse/minintro.nvim")
Plug("errata-ai/vale")
Plug("folke/todo-comments.nvim")
Plug("hrsh7th/cmp-buffer")
Plug("hrsh7th/cmp-cmdline")
Plug("hrsh7th/cmp-nvim-lsp")
Plug("hrsh7th/cmp-path")
Plug("hrsh7th/nvim-cmp")
Plug("kristijanhusak/vim-carbon-now-sh")
Plug("luckasRanarison/nvim-devdocs")
Plug("mfussenegger/nvim-lint")
Plug("neovim/nvim-lspconfig")
Plug("nvim-lua/plenary.nvim")
Plug("nvim-lua/popup.nvim")
Plug("nvim-lualine/lualine.nvim")
Plug("nvim-telescope/telescope-file-browser.nvim")
Plug("nvim-telescope/telescope.nvim")
Plug("nvim-treesitter/nvim-treesitter")
Plug("prichrd/netrw.nvim")
Plug("rafamadriz/friendly-snippets")
Plug("rinx/nvim-ripgrep")
Plug("saadparwaiz1/cmp_luasnip")
Plug("stevearc/conform.nvim")
Plug("tadmccorkle/markdown.nvim")
Plug("tree-sitter/tree-sitter")
Plug("tree-sitter/tree-sitter-html")
vim.call("plug#end")

-- SETUP
vim.g.mapleader = ","
vim.opt.termguicolors = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.autochdir = true
vim.opt.mousescroll = "ver:1" -- fixes scrolling with mini.animate

require("mini.ai").setup()
require("mini.animate").setup()
require("mini.comment").setup()
require("mini.indentscope").setup({ symbol = vim.g.mapleader })
require("mini.jump").setup()
require("mini.notify").setup()
require("mini.pairs").setup()
require("mini.splitjoin").setup()
require("mini.surround").setup()
require("mini.tabline").setup()
require("mini.trailspace").setup()
require("mini.bufremove").setup()
require("mini.icons").setup()

require("lualine").setup({ theme = "dracula-nvim" })
require("markdown").setup()
require("minintro").setup({ color = "#af87ff" })
require("netrw").setup()
require("nvim-devdocs").setup()
require("nvim-treesitter").setup({ auto_install = true })
require("todo-comments").setup()
require("toggleterm").setup({ shade_terminals = true })
require("colorizer").setup()

require("dracula").setup({ italic_comment = true, transparent_bg = true })
vim.cmd([[colorscheme dracula]])

-- FORMATTER
require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		python = { "isort", "black" },
		javascript = { "prettier" },
		typescript = { "prettier" },
		sh = { "shellcheck", "shfmt" },
	},
})

-- SNIPPETS
require("luasnip.loaders.from_vscode").load({
	include = {
		"csharp",
		"html",
		"javascript",
		"lua",
		"markdown",
		"python",
		"rust",
		"shell",
		"typescript",
	},
})
require("luasnip").filetype_extend("typescript", { "angular" })

-- LINTING
local lint = require("lint")
lint.linters_by_ft = {
	javascript = { "eslint" },
	json = { "jsonlint" },
	lua = { "luacheck" },
	markdown = { "vale" },
	python = { "pylint" },
}

-- LANGUAGE SERVERS
local lspconfig = require("lspconfig")
lspconfig.pyright.setup({})
lspconfig.tsserver.setup({})
vim.api.nvim_create_autocmd(
	{ "BufWritePost" }, -- lint on save
	{
		callback = function()
			lint.try_lint()
			require("mini.trailspace").trim()
		end,
	}
)
vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- COMPLETION
local cmp = require("cmp")
cmp.setup({
	snippet = {
		expand = function(args)
			require("luasnip").lsp_expand(args.body)
		end,
	},
	window = {
		completion = cmp.config.window.bordered(),
		documentation = cmp.config.window.bordered(),
	},
	mapping = cmp.mapping.preset.insert({
		["<C-b>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<C-Space>"] = cmp.mapping.complete(),
		["<C-e>"] = cmp.mapping.abort(),
		["<CR>"] = cmp.mapping.confirm({ select = true }),
	}),
	sources = cmp.config.sources({ { name = "nvim_lsp" }, { name = "luasnip" } }, { { name = "buffer" } }),
})
cmp.setup.cmdline({ "/", "?" }, {
	mapping = cmp.mapping.preset.cmdline(),
	sources = { { name = "buffer" } },
})
cmp.setup.cmdline(":", {
	mapping = cmp.mapping.preset.cmdline(),
	sources = cmp.config.sources({ { name = "path" } }, { { name = "cmdline" } }),
	matching = { disallow_symbol_nonprefix_matching = false },
})
local capabilities = require("cmp_nvim_lsp").default_capabilities()
lspconfig["tsserver"].setup({ capabilities = capabilities })
lspconfig["pyright"].setup({ capabilities = capabilities })
