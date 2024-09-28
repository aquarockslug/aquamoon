-- AQUA ARCH NEOVIM
-- The main nvim configuration file
local vim = vim -- avoid undefined var warning

-- PLUGINS ---------------------------------------------------------------------
local Plug = vim.fn["plug#"]
vim.call("plug#begin", "/usr/share/nvim_plugged")

-- load mini plugins
for _, plugname in pairs({
	"animate",
	"surround",
	"ai",
	"comment",
	"icons",
	"indentscope",
	"jump",
	"notify",
	"pairs",
	"splitjoin", -- gS
	"trailspace",
}) do
	Plug("echasnovski/mini." .. plugname)
end

-- load other plugins
Plug("simeji/winresizer")
Plug("L3MON4D3/LuaSnip")
Plug("Mofiqul/dracula.nvim", { as = "dracula" })
Plug("MunifTanjim/nui.nvim")
Plug("NvChad/nvim-colorizer.lua")
Plug("akinsho/toggleterm.nvim")
Plug("eoh-bse/minintro.nvim")
Plug("errata-ai/vale")
Plug("folke/todo-comments.nvim")
Plug("hrsh7th/cmp-buffer")
Plug("hrsh7th/cmp-cmdline")
Plug("hrsh7th/cmp-nvim-lsp")
Plug("hrsh7th/cmp-path")
Plug("hrsh7th/nvim-cmp")
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
Plug("tree-sitter/tree-sitter")
Plug("tree-sitter/tree-sitter-html")
vim.call("plug#end")

-- SETUP ---------------------------------------------------------------------
vim.g.mapleader = ","
vim.opt.mousescroll = "ver:1" -- fixes scrolling with mini.animate
vim.opt.termguicolors = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.autochdir = true
vim.opt.scrolloff = 1000

require("mini.ai").setup()
require("mini.animate").setup()
require("mini.comment").setup()
require("mini.indentscope").setup({ symbol = "󰈿" })
require("mini.jump").setup()
require("mini.notify").setup()
require("mini.pairs").setup()
require("mini.splitjoin").setup()
require("mini.surround").setup()
require("mini.trailspace").setup()
require("mini.icons").setup()

require("lualine").setup({ theme = "dracula-nvim" })
require("minintro").setup({ color = "#af87ff" })
require("netrw").setup()
require("nvim-devdocs").setup()
require("nvim-treesitter").setup({ auto_install = true })
require("todo-comments").setup()
require("toggleterm").setup({ shade_terminals = true })
require("colorizer").setup()
-- require("winresizer").setup()

require("dracula").setup({ italic_comment = true, transparent_bg = true })
vim.cmd([[colorscheme dracula]])

-- FORMATTER -------------------------------------------------------------------
require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		python = { "isort", "black" },
		javascript = { "prettier" },
		typescript = { "prettier" },
		sh = { "shellcheck", "shfmt" },
	},
})

-- SNIPPETS --------------------------------------------------------------------
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

-- LINTING ---------------------------------------------------------------------
local lint = require("lint")
lint.linters_by_ft = {
	javascript = { "eslint" },
	json = { "jsonlint" },
	lua = { "luacheck" },
	markdown = { "vale" },
	python = { "pylint" },
	cs = { "csharp-ls" },
}

-- LANGUAGE SERVERS ------------------------------------------------------------
local lspconfig = require("lspconfig")
lspconfig.pyright.setup({})
lspconfig.ts_ls.setup({})
lspconfig.csharp_ls.setup({})
vim.api.nvim_create_autocmd(
	{ "BufWritePost" }, -- lint and trim on save
	{
		callback = function()
			lint.try_lint()
			require("mini.trailspace").trim()
		end,
	}
)

-- AUTO ----------------------------------------------------------------------
vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- COMPLETION ------------------------------------------------------------------
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
lspconfig["ts_ls"].setup({ capabilities = capabilities })
lspconfig["pyright"].setup({ capabilities = capabilities })
