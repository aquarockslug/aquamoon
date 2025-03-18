-- minimal config for javascript by Aquarock
local vim = vim -- avoid undefined warnings
vim.g.mapleader = ","
vim.g.maplocalleader = ","
-- vim.opt.autochdir = true
vim.opt.clipboard = "unnamedplus" -- allows neovim to access the system clipboard
vim.opt.cmdheight = 0
vim.opt.laststatus = 1
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.scrolloff = 10000
vim.opt.signcolumn = "no"
vim.diagnostic.config({ signs = false })
vim.flag = "󰈿"
-- TODO remove extra netrw decorations

vim.api.nvim_create_user_command("W", "write", { nargs = 0 })
vim.api.nvim_create_user_command("S", "source %", { nargs = 0 })

local function format()
	vim.notify(vim.flag .. " formatting...", vim.log.levels.INFO)
	require("conform").format()
	vim.cmd.write()
end
local function cycle_colorscheme(colorschemes)
	local i = #colorschemes
	return function()
		i = i + 1
		vim.cmd.colorscheme(colorschemes[(i % #colorschemes) + 1])
		vim.api.nvim_set_hl(0, "SnacksIndent", { fg = "none" }) -- use the default color after switching
	end
end
local is_wsl = function() -- check if nvim is currently running on windows subsystem linux
	local version_file = io.open("/proc/version", "rb")
	if version_file ~= nil and string.find(version_file:read("*a"), "microsoft") then
		version_file:close()
		return true
	end
	return false
end

local setup_keymap = function()
	local snacks = Snacks
	for cmd, func in pairs({
		-- left hand
		a = vim.lsp.buf.hover, -- read documentation under cursor
		b = function()
			snacks.gitbrowse()
		end,
		c = function()
			require("mini.extra").pickers.hipatterns()
		end, -- view highlighted comments
		d = function()
			require("mini.extra").pickers.diagnostic()
		end,
		e = function()
			require("mini.files").open()
		end,
		r = function()
			require("grug-far").open()
		end, -- search and replace
		w = function()
			snacks.terminal()
		end,
		-- right hand
		j = function()
			snacks.picker.jumps()
		end,
		m = function()
			snacks.picker.colorschemes()
		end,
		n = cycle_colorscheme({ "dracula", "desert", "everforest", "nightfall" }),
		u = function()
			snacks.picker.undo()
		end,
	}) do
		vim.keymap.set("n", "<leader>" .. cmd, func)
	end
	vim.keymap.set("n", "<leader>/", vim.cmd.noh) -- clear highlighting
	vim.keymap.set("n", "q:", "") -- prevent this typo from opening a window
	snacks.toggle.option("spell"):map("<leader>ts")
	snacks.toggle.diagnostics():map("<leader>td")
	vim.keymap.set("n", "U", "<c-r>")
	-- insert line above or below without going into insert mode
	vim.keymap.set("n", "gO", "<Cmd>call append(line('.') - 1, repeat([''], v:count1))<CR>")
	vim.keymap.set("n", "go", "<Cmd>call append(line('.'),     repeat([''], v:count1))<CR>")

	for cmd, func in pairs({
		[1] = function()
			require("lazygit-confirm").confirm()
		end,
		[2] = function()
			vim.notify(vim.flag .. " formatting...", vim.log.levels.INFO)
			require("conform").format()
			vim.cmd.write()
		end,
		-- [3] previous flag bookmark
		-- [4] next flag bookmark
	}) do
		vim.keymap.set("i", "<F" .. cmd .. ">", func)
		vim.keymap.set("n", "<F" .. cmd .. ">", func)
	end
end
local setup_autocmds = function()
	vim.api.nvim_create_autocmd("BufWritePost", {
		callback = function()
			require("mini.trailspace").trim()
			vim.notify(vim.flag .. " wrote " .. vim.fn.expand("%:p"), vim.log.levels.INFO)
		end,
	})
	vim.api.nvim_create_autocmd("InsertEnter", {
		callback = function()
			Snacks.toggle.option("cursorline"):set(true)
		end,
	})
	vim.api.nvim_create_autocmd("InsertLeave", {
		callback = function()
			Snacks.toggle.option("cursorline"):set(false)
		end,
	})
	vim.api.nvim_create_autocmd("TextYankPost", {
		callback = function()
			vim.highlight.on_yank({ higroup = "DiffAdd", timeout = 250 })
		end,
	})
end
local setup_highlighters = function()
	-- vim.api.nvim_set_hl(0, 'ColorColumn', { fg = "#FF5555" }) -- TODO make letters warn color
	-- vim.api.nvim_set_hl(0, "SnacksIndent", { fg = "#0E131B" }) -- TODO remove lines completely, or link bg color hl group
	vim.api.nvim_set_hl(0, "MiniHipatternsWarn", { bg = "#FF5555", fg = "#FFFFFF" })
	vim.api.nvim_set_hl(0, "MiniHipatternsHack", { bg = "#FFB86C" })
	vim.api.nvim_set_hl(0, "MiniHipatternsTodo", { bg = "#8BE9FD" })
end

-- MINI
local path_package = vim.fn.stdpath("data") .. "/site/"
local mini_path = path_package .. "pack/deps/start/mini.nvim"
if not vim.loop.fs_stat(mini_path) then
	vim.notify("Installing mini.nvim", vim.log.levels.INFO)
	vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/echasnovski/mini.nvim", mini_path })
	vim.cmd("packadd mini.nvim | helptags ALL")
	vim.notify("Installed mini.nvim", vim.log.levels.INFO)
end
require("mini.deps").setup({ path = { package = path_package } })
local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later
for _, plug in ipairs({ -- mini plug to load later using their default config
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
	"files",
}) do
	later(function()
		require("mini." .. plug).setup()
	end)
end
now(function() -- mini setup
	require("mini.starter").setup()
	require("mini.hipatterns").setup({
		highlighters = {
			WARN = { pattern = "%f[%w]()WARN()%f[%W]", group = "MiniHipatternsWarn" },
			HACK = { pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHipatternsHack" },
			TODO = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
		},
	})
	require("mini.pick").setup({
		window = { prompt_prefix = vim.flag .. " " },
		options = { content_from_bottom = true },
	})
end)

-- SNACKS
now(function()
	add({ source = "folke/snacks.nvim" })
	require("snacks").setup({
		bigfile = { enabled = true },
		notifier = { enabled = true },
		quickfile = { enabled = true },
		rename = { enabled = true },
		indent = {
			animate = { style = "down" },
			chunk = { enabled = true, char = { corner_top = "╭", corner_bottom = "╰" } },
			scope = { enabled = false },
		},
	})
	add({ source = "dchae/canter.nvim" })
	add({ source = "thelastpsion/lazygit-confirm.nvim" })
end)

-- BLINK
now(function()
	add({
		source = "Saghen/blink.cmp",
		depends = { "neovim/nvim-lspconfig", "rafamadriz/friendly-snippets" },
	})
	require("blink.cmp").setup({ keymap = { preset = "super-tab" } })
	require("lspconfig")["biome"].setup({})
	require("lspconfig")["stylua3p_ls"].setup({})
	add({ source = "stevearc/conform.nvim" })
	require("conform").setup({ -- cant use vim.lsp.buf.format because it clears marks
		formatters_by_ft = { javascript = { "biome" }, lua = { "stylua" } },
	})
end)
-- TODO automatically build on update

-- OTHER
now(function()
	add({ source = "2giosangmitom/nightfall.nvim" })
	require("nightfall").setup({})
	add({ source = "Mofiqul/dracula.nvim" })
	require("dracula").load()
	add({ source = "neanias/everforest-nvim.git" })
	require("everforest").setup()
	add({ source = "tzachar/highlight-undo.nvim" })
	require("highlight-undo").setup()
	add({ source = "sphamba/smear-cursor.nvim" })
	require("smear_cursor").setup()
end)
now(function()
	add({ source = "MeanderingProgrammer/render-markdown.nvim" })
	require("render-markdown").setup({})
	require("render-markdown").enable()
	-- add({ source = 'jghauser/follow-md-links.nvim' }); require('follow-md-links').setup();
	-- vim.keymap.set('n', '<bs>', ':edit #<cr>', { silent = true })
end)
now(function()
	add({ source = "tpope/vim-eunuch" })
	add({
		source = "brianhuster/dirvish-git.nvim",
		depends = { "justinmk/vim-dirvish" },
	})
end)
now(function()
	add({
		source = "nvim-treesitter/nvim-treesitter",
		checkout = "master",
		monitor = "main",
		hooks = {
			post_checkout = function()
				vim.cmd("TSUpdate")
			end,
		},
	})
	require("nvim-treesitter.configs").setup({ highlight = { enable = true } })
end)
later(function()
	add({ source = "MagicDuck/grug-far.nvim" })
	require("grug-far").setup({}) -- find and replace
	add({ source = "andrewferrier/debugprint.nvim" }) -- generates print statements for variables
	require("debugprint").setup({ keymaps = { normal = { variable_below = "gp", delete_debug_prints = "gP" } } })
end)
later(function()
	add({ source = "chentoast/marks.nvim" })
	require("marks").setup({ -- builtin_marks = { "<", ">", "^", "." },
		mappings = { -- up/down navigates marks, left right navigates flag bookmark
			prev_bookmark0 = "<F3>",
			next_bookmark0 = "<F4>",
			set_bookmark0 = ",f",
			delete_bookmark0 = ",F",
		},
		bookmark_0 = {
			sign = vim.flag,
			virt_text = vim.flag,
		},
	})
end)
later(function()
	add({ source = "swaits/zellij-nav.nvim" })
	require("zellij-nav").setup()
	vim.keymap.set("n", "<up>", function()
		vim.cmd("ZellijNavigateUp")
	end)
	vim.keymap.set("n", "<down>", function()
		vim.cmd("ZellijNavigateDown")
	end)
	vim.keymap.set("n", "<left>", function()
		vim.cmd("ZellijNavigateLeft")
	end)
	vim.keymap.set("n", "<right>", function()
		vim.cmd("ZellijNavigateRight")
	end)
end)
if is_wsl() then -- https://github.com/memoryInject/wsl-clipboard
	vim.g.clipboard = {
		name = "wsl-clipboard",
		copy = { ["+"] = "wcopy", ["*"] = "wcopy" },
		paste = { ["+"] = "wpaste", ["*"] = "wpaste" },
		cache_enabled = true,
	}
	require("dracula").load()
else
	-- require("nightfall").load("nightfall")
	require("everforest").load()
end
-- TODO set theme based on time of day
setup_autocmds()
setup_highlighters()
setup_keymap()
