local vim = vim
local path_package = vim.fn.stdpath('data') .. '/site/'
local mini_path = path_package .. 'pack/deps/start/mini.nvim'
if not vim.loop.fs_stat(mini_path) then
	vim.cmd('echo "Installing `mini.nvim`" | redraw')
	local clone_cmd = { 'git', 'clone', '--filter=blob:none', 'https://github.com/echasnovski/mini.nvim', mini_path }
	vim.fn.system(clone_cmd)
	vim.cmd('packadd mini.nvim | helptags ALL')
	vim.cmd('echo "Installed `mini.nvim`" | redraw')
end

require('mini.deps').setup({ path = { package = path_package } })
local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

-- Safely execute immediately
now(function()
	vim.o.termguicolors = true
	vim.g.mapleader = ","
	vim.opt.mousescroll = "ver:1" -- fixes scrolling with mini.animate
	vim.opt.termguicolors = true
	vim.opt.autochdir = true
	vim.opt.scrolloff = 1000
end)
now(function() require('mini.icons').setup() end)
now(function() require('mini.tabline').setup() end)
now(function() require('mini.statusline').setup() end)
now(function() require('mini.starter').setup() end)
now(function()
	require('mini.notify').setup()
	vim.notify = require('mini.notify').make_notify()
end)

-- Safely execute later
later(function() require('mini.ai').setup() end)
later(function() require('mini.comment').setup() end)
later(function() require('mini.pick').setup() end)
later(function() require('mini.surround').setup() end)
later(function() require('mini.pairs').setup() end)
later(function() require('mini.trailspace').setup() end)
later(function() require('mini.splitjoin').setup() end)
later(function() require('mini.animate').setup() end)
later(function() require("mini.indentscope").setup({ symbol = "󰈿" }) end)

-- opt plugins
now(function() -- theme
	add({ source = 'Mofiqul/dracula.nvim', as = 'dracula' })
	require("dracula").setup({ italic_comment = true, transparent_bg = true })
	vim.cmd([[colorscheme dracula]])
end)

now(function()
	add({ -- terminal
		source = 'akinsho/toggleterm.nvim',
	}) -- needs to load now because the config files reference it
end)

now(function() -- lsp
	add({
		source = 'hrsh7th/cmp-nvim-lsp.git',
		depends = { 'williamboman/mason.nvim', 'williamboman/mason-lspconfig.nvim',
			'neovim/nvim-lspconfig', 'hrsh7th/cmp-nvim-lsp' },
	})
	require("mason").setup()
	require("mason-lspconfig").setup({})
	require('cmp').setup { sources = { { name = 'nvim_lsp' } } }
	local c = require('cmp_nvim_lsp').default_capabilities()
	require('lspconfig').lua_ls.setup { capabilities = c }
	require('lspconfig').ast_grep.setup { capabilities = c }
	require('lspconfig').basedpyright.setup { capabilities = c }
	require('lspconfig').omnisharp.setup { capabilities = c }
	require('lspconfig').bashls.setup { capabilities = c }
end)

later(function() -- file browsing
	add({
		source = 'prichrd/netrw.nvim',
	})
end)

later(function() -- treesitter
	add({
		source = 'nvim-treesitter/nvim-treesitter',
		checkout = 'master',
		monitor = 'main',
		hooks = { post_checkout = function() vim.cmd('TSUpdate') end },
	})
	require('nvim-treesitter.configs').setup({ highlight = { enable = true } })
end)

-- AUTOCMD
vim.api.nvim_create_autocmd("BufWritePost", { callback = require("mini.trailspace").trim })
vim.api.nvim_create_autocmd("TextYankPost", { callback = vim.highlight.on_yank })
