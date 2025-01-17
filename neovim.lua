-- %%% Aqua's nvim %%%

-- %% Settings %%
local vim = vim -- avoid undefined warnings
vim.g.mapleader = ","
vim.g.maplocalleader = ','
vim.g.netrw_banner = 0
vim.g.netrw_liststyle = 3 -- set the styling of the file list to be a tree
vim.opt.cmdheight = 0
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.autochdir = true
vim.opt.scrolloff = 1000
vim.opt.clipboard = "unnamedplus" -- allows neovim to access the system clipboard
vim.diagnostic.config({ signs = false })
vim.loader.enable()

vim.dracula_green = "#50FA7B"
vim.dracula_orange = "#FFB86C"
vim.dracula_purple = "#BD93F9"
vim.dracula_bg = "#282A36"
vim.flag = "󰈿" -- TODO color flag
vim.flag_shell = function(cmd)
	os.execute(cmd); vim.notify(vim.flag .. ' ' .. cmd)
end

local setup_autocmds = function()
	vim.api.nvim_create_autocmd("BufWritePost", {
		callback = function()
			require("mini.trailspace").trim()
			vim.notify(vim.flag .. ' wrote ' .. vim.fn.expand('%:p'), vim.log.levels.INFO)
		end
	})
	vim.api.nvim_create_autocmd("InsertEnter", {
		callback = function()
			Snacks.toggle.option("cursorline"):set(true)
			vim.opt.cc = "100"
		end
	})
	vim.api.nvim_create_autocmd("InsertLeave", {
		callback = function()
			Snacks.toggle.option("cursorline"):set(false)
			vim.opt.cc = "0"
		end
	})
	vim.api.nvim_create_autocmd("TextYankPost", {
		callback = function() vim.highlight.on_yank { higroup = "DiffAdd", timeout = 250 } end })
end

-- % leader shortcuts %
local setup_keymap = function()
	local snacks = Snacks

	vim.keymap.set("n", "U", "<c-r>")

	-- insert line above or below without going into insert mode
	vim.keymap.set('n', 'gO', "<Cmd>call append(line('.') - 1, repeat([''], v:count1))<CR>")
	vim.keymap.set('n', 'go', "<Cmd>call append(line('.'),     repeat([''], v:count1))<CR>")

	vim.zjedit = function(zjargs)
		require('mini.pick').builtin.files({ tool = 'git' }, {
			source = {
				name = 'edit...',
				choose = function(filename)
					vim.flag_shell('zellij run ' .. zjargs .. ' -- nvim ' .. filename)
				end
			}
		})
	end

	-- leader keymaps
	local pickers = require("mini.extra").pickers
	vim.keymap.set("n", "<leader>/", vim.cmd.noh) -- clear highlighting
	for cmd, func in pairs({
		-- r = vim.lsp.buf.rename,
		E = function() vim.zjedit('-c -d right') end,
		a = vim.lsp.buf.hover, -- read documentation under cursor
		b = function() snacks.gitbrowse() end,
		e = function() MiniFiles.open() end,
		r = require('grug-far').open, -- search and replace
		w = function() snacks.terminal() end,

		-- picker keymaps
		c = pickers.hipatterns, -- view highlighted comments
		d = pickers.diagnostic,
		-- f = pickers.marks,
		g = require("mini.pick").builtin.grep_live,
		s = pickers.spellsuggest,
	}) do vim.keymap.set("n", "<leader>" .. cmd, func) end

	-- function keymaps
	for cmd, func in pairs({
		-- right hand, third layer of keyboard: lazygit, format, scratch, files
		[1] = function() snacks.lazygit() end,
		[2] = function()
			vim.notify(vim.flag .. ' formatting...', vim.log.levels.INFO)
			vim.lsp.buf.format()
			vim.cmd.write()
		end,
		[3] = function() snacks.scratch.open() end, -- TODO append current line, appendbufline
		[4] = function() snacks.terminal.open('sh -c $(gum choose nap cht ddgr oil docs)') end,
		-- left hand, second layer of keyboard
		[5] = function() -- run file
			vim.cmd.write()
			vim.notify(vim.flag .. ' executing...', vim.log.levels.INFO)
			snacks.terminal.open('python ' .. vim.fn.expand('%:p'))
		end, -- TODO detect filetype
		[6] = function() -- run file
			vim.cmd.write()
			vim.notify(vim.flag .. ' executing...', vim.log.levels.INFO)
			snacks.terminal.open('node ' .. vim.fn.expand('%:p'))
		end,
	}) do
		vim.keymap.set("i", "<F" .. cmd .. ">", func)
		vim.keymap.set("n", "<F" .. cmd .. ">", func)
	end

	-- Snacks option toggle keybinds
	snacks.toggle.option("spell"):map("<leader>ts")
	snacks.toggle.option("cursorline"):map("<leader>tC")
	snacks.toggle.option("wrap"):map("<leader>tw")
	snacks.toggle.option("relativenumber"):map("<leader>tL")
	snacks.toggle.line_number():map("<leader>tl")
	snacks.toggle.diagnostics():map("<leader>td")
	snacks.toggle.option("conceallevel",
		{ off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 }):map("<leader>tc")
	snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map("<leader>tb")
end

local setup_highlighters = function()
	vim.api.nvim_set_hl(0, 'MiniHipatternsWarn', { bg = "#FF5555", fg = "#FFFFFF" })
	vim.api.nvim_set_hl(0, 'MiniHipatternsHack', { bg = "#FFB86C", fg = vim.dracula_bg })
	vim.api.nvim_set_hl(0, 'MiniHipatternsTodo', { bg = "#8BE9FD", fg = vim.dracula_bg })
	vim.api.nvim_set_hl(0, 'MiniPickBorder', { fg = vim.dracula_green, bg = vim.dracula_bg })
	vim.api.nvim_set_hl(0, 'MiniPickPrompt', { fg = vim.dracula_orange, bg = vim.dracula_bg })
	vim.api.nvim_set_hl(0, 'MiniFilesBorder', { fg = vim.dracula_green, bg = vim.dracula_bg })
	vim.api.nvim_set_hl(0, 'MiniStatuslineModeOther', { fg = vim.dracula_orange })
	for _, group in ipairs({
		'MiniStatuslineModeNormal', 'MiniStatuslineModeInsert', 'MiniStatuslineDevinfo', 'MiniStatuslineFileinfo',
		'MiniStatuslineFilename', 'MiniJump', 'MiniJump2dSpot', 'MiniStarterHeader', 'MiniStarterFooter',
		'MiniStarterQuery', 'GrugFarInputLabel', 'GrugFarHelpHeader', 'MiniNotifierBorderInfo', 'MiniNotifierTitleInfo'
	}) do vim.api.nvim_set_hl(0, group, { fg = vim.dracula_orange }) end
	-- vim.api.nvim_set_hl(0, 'ColorColumn', { bg = vim.dracula_green }) TODO fix color col color
end

-- % wsl %
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
	vim.notify('Installing mini.nvim', vim.log.levels.INFO)
	vim.fn.system({ 'git', 'clone', '--filter=blob:none', 'https://github.com/echasnovski/mini.nvim', mini_path })
	vim.cmd('packadd mini.nvim | helptags ALL')
	vim.notify('Installed mini.nvim', vim.log.levels.INFO)
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
-- now(function() # TODO make a leader shortcut to toggle this
-- 	add({ source = 'niuiic/divider.nvim' }); require('divider').setup({})
-- end)
now(function()
	add({ source = 'andrewferrier/debugprint.nvim' }) -- generates print statements for variables
	require('debugprint').setup({ keymaps = { normal = { variable_below = "gp", delete_debug_prints = "gP" } } })
end)
now(function()
	add({ source = 'MeanderingProgrammer/render-markdown.nvim' });
	require('render-markdown').setup({});
	require('render-markdown').enable()
end)
later(function()
	add({ source = 'sphamba/smear-cursor.nvim' })
	require('smear_cursor').setup()
end)
later(function()
	add({ source = 'tzachar/highlight-undo.nvim' })
	require('highlight-undo').setup()
end)

-- % dracula %
now(function()
	add({ source = 'Mofiqul/dracula.nvim', as = 'dracula' })
	require("dracula").setup({ italic_comment = true, transparent_bg = true })
	vim.cmd([[colorscheme dracula]])
end)

-- % lsp and completion %
now(function()
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
		"lua_ls", "basedpyright", "ruff", "bashls", "biome", "csharp_ls", "markdown_oxide"
	}) do require("lspconfig")[lang_server].setup {} end
	vim.cmd.LspStart()
end)
now(function()
	require('mini.hipatterns').setup({
		highlighters = {
			warn = { pattern = '%f[%w]()WARN()%f[%W]', group = 'MiniHipatternsWarn' },
			hack = { pattern = '%f[%w]()HACK()%f[%W]', group = 'MiniHipatternsHack' },
			todo = { pattern = '%f[%w]()TODO()%f[%W]', group = 'MiniHipatternsTodo' },
		}
	})
end)

-- % snacks %
now(function()
	-- if Snacks.did_setup then exit func
	add({ source = 'folke/snacks.nvim' });
	require('snacks').setup({
		bigfile = { enabled = true },
		input = { enabled = true },
		notifier = { enabled = true },
		quickfile = { enabled = true },
		rename = { enabled = true },
	})
	Snacks.indent.enable()
end)

-- %% LATER %%
for _, plug in ipairs({                                                 -- mini plugs
	"comment", "diff", "extra", "fuzzy", "jump", "jump2d", "visits", "ai", -- "animate",
	"misc", "pairs", "pick", "surround", "trailspace", "colors", "files"
}) do later(function() require('mini.' .. plug).setup() end) end
later(function() add({ source = 'simeji/winresizer' }) end)         -- <C-e> to resize, then 'e' to move
later(function()
	add({ source = 'chentoast/marks.nvim' }); require('marks').setup { -- builtin_marks = { "<", ">", "^", "." },
		mappings = {                                        -- up/down navigates marks, left right navigates flag bookmark
			prev = '9',
			next = '8',
			prev_bookmark0 = '7',
			next_bookmark0 = '0',
			set_bookmark0 = ',f',
			delete_bookmark0 = ',F'
		},
		bookmark_0 = {
			sign = vim.flag,
			virt_text = vim.flag,
		},
	}
end)
later(function() -- search and replace
	add({ source = 'MagicDuck/grug-far.nvim' }); require('grug-far').setup {}
end)
later(function()
	MiniPick.config.window.prompt_prefix = ' ' .. vim.flag .. ' ';
	MiniPick.config.options.use_cache = true;
end)

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
later(setup_keymap)
setup_highlighters()
