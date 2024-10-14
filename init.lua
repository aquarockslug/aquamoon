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
later(function() require('mini.diff').setup() end)
later(function() require('mini.doc').setup() end)
later(function() require('mini.fuzzy').setup() end)
later(function() require('mini.hipatterns').setup() end)
later(function() require('mini.jump').setup() end)
later(function() require('mini.pick').setup() end)
later(function() require('mini.surround').setup() end)
later(function() require('mini.pairs').setup() end)
later(function() require('mini.trailspace').setup() end)
later(function() require('mini.splitjoin').setup() end)
later(function() require('mini.animate').setup() end)
later(function() require("mini.indentscope").setup({ symbol = "󰈿" }) end)

-- OPT PLUGINS ( non mini.nvim plugins )
now(function() -- theme
	add({ source = 'Mofiqul/dracula.nvim', as = 'dracula' })
	require("dracula").setup({ italic_comment = true, transparent_bg = true })
	vim.cmd([[colorscheme dracula]])
end)

now(function() -- terminal
	add({ source = 'akinsho/toggleterm.nvim' })
end)           -- needs to load now because the config files reference it

now(function() -- lsp
	add({
		source = 'Saghen/blink.cmp',
		depends = { 'williamboman/mason.nvim', 'williamboman/mason-lspconfig.nvim',
			'neovim/nvim-lspconfig', 'rafamadriz/friendly-snippets' },
	})
	require("mason").setup()
	require("mason-lspconfig").setup {}
	require('blink.cmp').setup {}
	require('lspconfig').lua_ls.setup {}
	require('lspconfig').ast_grep.setup {}
	require('lspconfig').basedpyright.setup {}
	require('lspconfig').omnisharp.setup {}
	require('lspconfig').bashls.setup {}
end)

later(function() -- file browsing
	add({ source = 'prichrd/netrw.nvim' })
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
