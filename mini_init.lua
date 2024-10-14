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
now(function() vim.o.termguicolors = true end)
now(function() require('mini.icons').setup() end)
now(function() require('mini.tabline').setup() end)
now(function() require('mini.statusline').setup() end)
now(function() require('mini.animate').setup() end)
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

now(function() add({ -- theme
    source = 'Mofiqul/dracula.nvim',
    as = 'dracula'
  })
  require("dracula").setup({ italic_comment = true, transparent_bg = true })
  vim.cmd([[colorscheme dracula]])
end)

now(function() add({ -- terminal
    source = 'akinsho/toggleterm.nvim',
  }) -- needs to load now because the config files reference it
end)

now(function() add({ -- lsp
    source = 'neovim/nvim-lspconfig',
    depends = { 'williamboman/mason.nvim', 'williamboman/mason-lspconfig.nvim' },
  })
  require("mason").setup()
  require("mason-lspconfig").setup()
  require('lspconfig').lua_ls.setup()
end)

later(function() add({ -- file browsing
    source = 'prichrd/netrw.nvim',
  })
end)

later(function() add({ -- completion
    source = 'saghen/blink.nvim',
    depends = { 'rafamadriz/friendly-snippets' },
  })
end)

later(function() add({ -- treesitter
    source = 'nvim-treesitter/nvim-treesitter',
    checkout = 'master',
    monitor = 'main',
    hooks = { post_checkout = function() vim.cmd('TSUpdate') end },
  })
  require('nvim-treesitter.configs').setup({
    ensure_installed = { 'lua', 'vimdoc' },
    highlight = { enable = true },
  })
end)

-- AUTOCMD
vim.api.nvim_create_autocmd("BufWritePost", {
        callback = require("mini.trailspace").trim
})
vim.api.nvim_create_autocmd("TextYankPost", {
        callback = vim.highlight.on_yank
})
