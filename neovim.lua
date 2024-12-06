-- %%% Aqua's nvim %%%

-- %% Settings %%
local vim = vim               -- avoid undefined warnings
vim.g.mapleader = ","
vim.opt.mousescroll = "ver:1" -- fixes scrolling with mini.animate
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.autochdir = true
vim.opt.scrolloff = 1000
vim.opt.clipboard = "unnamedplus" -- allows neovim to access the system clipboard
vim.diagnostic.config({ signs = false })
vim.g.netrw_banner = 0
vim.g.netrw_liststyle = 3 -- set the styling of the file list to be a tree
vim.loader.enable()

local setup_autocmds = function()
	vim.api.nvim_create_autocmd("BufWritePost", { callback = require("mini.trailspace").trim })
	vim.api.nvim_create_autocmd('TextYankPost', {
		callback = function() vim.highlight.on_yank { higroup = 'DiffAdd', timeout = 250 } end,
	})
end

-- % leader shortcuts %
local setup_keymap = function()
	local snacks = Snacks

	vim.keymap.set("n", "u", vim.cmd.undo)
	vim.keymap.set("n", "<c-u>", "10k")
	vim.keymap.set("n", "<c-d>", "10j")
	vim.keymap.set("n", "(", function() snacks.words.jump(-vim.v.count1) end)
	vim.keymap.set("n", ")", function() snacks.words.jump(vim.v.count1) end)
	vim.keymap.set("n", "<leader>/", function() snacks.terminal() end)

	-- leader keymaps
	for cmd, func in pairs({
		w = require("mini.extra").pickers.spellsuggest,
		V = vim.cmd.Hexplore, -- open netrw in horizontal pane
		d = require("mini.extra").pickers.diagnostic,
		a = require("mini.pick").builtin.grep_live,
		f = function() require("flash").jump() end,
		g = function() Snacks.gitbrowse() end,
		h = vim.cmd.noh, -- clear highlighting
		i = vim.lsp.buf.hover, -- documentation under cursor
		o = require("mini.extra").pickers.oldfiles,
		r = require("mini.extra").pickers.registers,
		s = function() require("mini.extra").pickers.lsp({ scope = "document_symbol" }) end,
		v = vim.cmd.Vexplore, -- open netrw in vertical pane
	}) do vim.keymap.set("n", "<leader>" .. cmd, func) end

	for cmd, func in pairs({
		[1] = function() Snacks.lazygit() end,
		[2] = vim.lsp.buf.format,
		[3] = function() Snacks.terminal.open('sh -c $(gum choose ddgr oil docs)') end,
		[4] = function() Snacks.terminal.open("nap") end,
	}) do vim.keymap.set("n", "<F" .. cmd .. ">", func) end

	-- Snacks option toggle keybinds
	Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>ts")
	Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>tw")
	Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>tL")
	Snacks.toggle.line_number():map("<leader>tl")
	Snacks.toggle.diagnostics():map("<leader>td")
	Snacks.toggle.option("conceallevel",
		{ off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 }):map("<leader>tc")
	Snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map("<leader>tb")
end

local setup_highlighters = function()
	vim.api.nvim_set_hl(0, 'MiniHipatternsFixme', { bg = "#FF5555", fg = "#FFFFFF" })
	vim.api.nvim_set_hl(0, 'MiniHipatternsHack', { bg = "#FFB86C", fg = "#000000" })
	vim.api.nvim_set_hl(0, 'MiniHipatternsTodo', { bg = "#8BE9FD", fg = "#000000" })
end

-- % WSL %
local is_wsl = function() -- check if nvim is currently running on windows subsystem linux
	local version_file = io.open("/proc/version", "rb")
	if version_file ~= nil and string.find(version_file:read("*a"), "microsoft") then
		version_file:close()
		return true
	end
	return false
end

if is_wsl() then -- https://github.com/memoryInject/wsl-clipboard
	vim.g.clipboard = {
		name = "wsl-clipboard",
		copy = { ["+"] = "wcopy", ["*"] = "wcopy" },
		paste = { ["+"] = "wpaste", ["*"] = "wpaste" },
		cache_enabled = true,
	}
end

-- % setup mini.deps %
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

local function build_blink(params)
	vim.notify('Building blink.cmp', vim.log.levels.INFO)
	local obj = vim.system({ 'cargo', 'build', '--release' }, { cwd = params.path }):wait()
	if obj.code == 0 then
		vim.notify('Building blink.cmp done', vim.log.levels.INFO)
	else
		vim.notify('Building blink.cmp failed', vim.log.levels.ERROR)
	end
end

-- %% NOW %%
now(function() require('mini.icons').setup() end)
now(function() require('mini.statusline').setup() end)
now(function() require('mini.starter').setup() end)
-- now(function()
-- 	add({ source = 'prichrd/netrw.nvim' }); require("netrw").setup({});
-- end)
now(function()
	add({ source = 'niuiic/divider.nvim' }); require('divider').setup({})
end)
now(function()
	add({ source = 'MeanderingProgrammer/render-markdown.nvim' });
	require('render-markdown').setup({});
	require('render-markdown').enable()
end)

-- % snacks %
now(function()
	add({ source = 'folke/snacks.nvim' });
	require('snacks').setup({
		bigfile = { enabled = true },
		notifier = { enabled = true },
		quickfile = { enabled = true },
		words = { enabled = true },
	})
end)

-- % dracula %
now(function()
	add({ source = 'Mofiqul/dracula.nvim', as = 'dracula' })
	require("dracula").setup({ italic_comment = true, transparent_bg = true })
	vim.cmd([[colorscheme dracula]])
end)

-- % lsp and completion %
later(function()
	add({
		source = 'Saghen/blink.cmp',
		depends = { 'williamboman/mason.nvim', 'williamboman/mason-lspconfig.nvim',
			'neovim/nvim-lspconfig', 'rafamadriz/friendly-snippets' },
		hooks = { --  blink.cmp doesnt use the stable version of rust
			post_install = build_blink, post_checkout = build_blink,
		},
	})
	require("mason").setup()
	require("mason-lspconfig").setup {}
	require("blink.cmp").setup { keymap = { preset = 'super-tab' } }
	for _, lang_server in ipairs({
		"lua_ls", "basedpyright", "ruff", "bashls", "biome", "csharp_ls"
	}) do require("lspconfig")[lang_server].setup {} end
	vim.cmd.LspStart()
end)
now(function() -- highlight patterns
	local hipatterns = require('mini.hipatterns')
	hipatterns.setup({
		highlighters = {
			fixme = { pattern = '%f[%w]()WARN()%f[%W]', group = 'MiniHipatternsFixme' },
			hack  = { pattern = '%f[%w]()HACK()%f[%W]', group = 'MiniHipatternsHack' },
			todo  = { pattern = '%f[%w]()TODO()%f[%W]', group = 'MiniHipatternsTodo' },
		}
	})
end)

-- %% LATER %%
for _, plug in ipairs({
	"animate", "comment", "diff", "extra", "fuzzy", "jump", "visits",
	"misc", "pairs", "pick", "surround", "trailspace",
}) do later(function() require('mini.' .. plug).setup() end) end
later(function() require("mini.indentscope").setup({ symbol = "󰈿" }) end)
later(function() add({ source = 'folke/flash.nvim' }) end)
later(function() add({ source = 'simeji/winresizer' }) end)         -- <C-e> to resize, then 'e' to move
later(function() add({ source = 'kwkarlwang/bufresize.nvim' }) end) -- automatically update buffer size

-- % movement %
later(function()
	add({ source = 'swaits/zellij-nav.nvim' })
	require('zellij-nav').setup()

	vim.keymap.set("n", "<up>", function() vim.cmd("ZellijNavigateUp") end)
	vim.keymap.set("n", "<down>", function() vim.cmd("ZellijNavigateDown") end)
	vim.keymap.set("n", "<left>", function() vim.cmd("ZellijNavigateLeft") end)
	vim.keymap.set("n", "<right>", function() vim.cmd("ZellijNavigateRight") end)

	vim.keymap.set("n", "<C-up>", vim.cmd.tabs)
	vim.keymap.set("n", "<C-down>", vim.cmd.quit)
	vim.keymap.set("n", "<C-left>", vim.cmd.tabprevious)
	vim.keymap.set("n", "<C-right>", vim.cmd.tabnext)
end)
-- % treesitter %
later(function()
	add({
		source = 'nvim-treesitter/nvim-treesitter',
		checkout = 'master',
		monitor = 'main',
		hooks = { post_checkout = function() vim.cmd('TSUpdate') end },
	})
	require('nvim-treesitter.configs').setup({ highlight = { enable = true } })
end)

setup_autocmds()
setup_keymap()
setup_highlighters()
