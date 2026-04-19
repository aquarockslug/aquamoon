-- Main Neovim configuration for Aquamoon desktop environment
-- Handles plugin bootstrapping, settings, keymaps, and UI configuration

local M = {}
local vim = vim

local function bootstrap_rocks()
	local install_location = vim.fs.joinpath(vim.fn.stdpath("data") --[[@as string]], "rocks")

	local rocks_config = {
		rocks_path = vim.fs.normalize(install_location),
	}

	vim.g.rocks_nvim = rocks_config

	local luarocks_path = {
		vim.fs.joinpath(rocks_config.rocks_path, "share", "lua", "5.1", "?.lua"),
		vim.fs.joinpath(rocks_config.rocks_path, "share", "lua", "5.1", "?", "init.lua"),
	}
	package.path = package.path .. ";" .. table.concat(luarocks_path, ";")

	local luarocks_cpath = {
		vim.fs.joinpath(rocks_config.rocks_path, "lib", "lua", "5.1", "?.so"),
		vim.fs.joinpath(rocks_config.rocks_path, "lib64", "lua", "5.1", "?.so"),
	}
	package.cpath = package.cpath .. ";" .. table.concat(luarocks_cpath, ";")

	vim.opt.runtimepath:append(vim.fs.joinpath(rocks_config.rocks_path, "lib", "luarocks", "rocks-5.1", "rocks.nvim",
		"*"))

	if not pcall(require, "rocks") then
		local rocks_location = vim.fs.joinpath(vim.fn.stdpath("cache") --[[@as string]], "rocks.nvim")

		if not vim.uv.fs_stat(rocks_location) then
			local url = "https://github.com/lumen-oss/rocks.nvim"
			vim.fn.system({ "git", "clone", "--filter=blob:none", url, rocks_location })
			assert(vim.v.shell_error == 0,
				"rocks.nvim installation failed. Try exiting and re-entering Neovim!")
		end

		vim.cmd.source(vim.fs.joinpath(rocks_location, "bootstrap.lua"))

		vim.fn.delete(rocks_location, "rf")
	end
end

bootstrap_rocks()

local S = dofile(os.getenv("HOME") .. "/.aquamoon/settings.lua")
package.path = package.path .. ";" .. S.path .. "/?.lua"
package.path = package.path .. ";" .. S.path .. "/?/init.lua"

vim.g.godot_executable = S.nvim.godot_executable
vim.g.lazygit_floating_window_scaling_factor = S.nvim.lazygit.scaling_factor
vim.g.lazygit_floating_window_border_chars = S.nvim.lazygit.border_chars
vim.flag = S.nvim.flag

vim.lsp.enable("lua_ls")
vim.lsp.enable("biome")
vim.diagnostic.config({
	signs = S.nvim.diagnostics.signs,
	virtual_lines = S.nvim.diagnostics.virtual_lines
})
vim.diagnostic.enable(S.nvim.diagnostics.enable)

vim.cmd.aqua_save = function()
	if vim.bo.filetype ~= "oil" and vim.bo.filetype ~= "ministarter" then
		MiniTrailspace.trim()
		vim.lsp.buf.format()
		require("scripts/sys/notify").send(require('lsp-status').status())
	end

	vim.cmd "silent write"
end

vim.api.nvim_create_autocmd("InsertEnter", {
	callback = function()
		vim.opt.cursorline = true
	end,
})
vim.api.nvim_create_autocmd("InsertLeave", {
	callback = function()
		vim.opt.cursorline = false
	end,
})
vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function() vim.hl.on_yank({ higroup = "LineNr", timeout = 250 }) end,
})
vim.api.nvim_create_autocmd("BufEnter", {
	pattern = { "*.jpg", "*.png", "*.ico" },
	callback = function()
		vim.cmd([[ terminal chafa % ]])
	end
})
vim.api.nvim_create_autocmd("BufEnter", {
	pattern = { "*.js", "*.gd", "*.lua", "*.md" },
	callback = function()
		vim.treesitter.start()
	end
})
vim.api.nvim_create_autocmd("BufEnter", {
	desc = "Sync nvim with oil's current directory",
	pattern = { "*/" },
	callback = function()
		vim.b.minicompletion_disable = true
		require("oil.actions").cd.callback()
	end
})
vim.api.nvim_create_autocmd("VimResized", {
	desc = "resize windows to be equal",
	callback = function() vim.cmd("tabdo wincmd =") end
})
vim.api.nvim_create_autocmd({ "TermOpen" }, {
	callback = function()
		vim.wo[0][0].scrolloff = 0
	end
})
vim.api.nvim_create_autocmd({ "TermClose", "TermLeave" }, {
	desc = "check for file changes when leaving the terminal",
	callback = function()
		vim.cmd.checktime()
	end
})

local theme = S.theme
local highlights = {
	LineNr = { bg = theme.background, fg = theme.text_primary },
	LineNrAbove = { fg = theme.text_primary },
	LineNrBelow = { fg = theme.text_primary },
	CursorLineNr = { fg = theme.text_primary },
	OilDir = { fg = theme.text_primary },
	LazyGitBorder = { fg = theme.text_primary },
	MiniStarterSection = { fg = theme.text_primary },
	MiniStarterItemPrefix = { fg = theme.accent },
	MiniStarterQuery = { fg = theme.accent },
	Cursor = { bg = theme.text_primary, fg = theme.background },
	lCursor = { bg = theme.text_primary, fg = theme.background },
	CursorIM = { bg = theme.accent, fg = theme.background },
}

for group, colors in pairs(highlights) do
	local attrs = {}
	if colors.bg then table.insert(attrs, "guibg=#" .. colors.bg) end
	if colors.fg then table.insert(attrs, "guifg=#" .. colors.fg) end
	vim.cmd.highlight(group .. " " .. table.concat(attrs, " "))
end

if vim.g.neovide then
	vim.g.neovide_opacity = S.theme.opacity
	vim.o.guifont = S.theme.active_font.name
	vim.g.neovide_text_gamma = 0.8
	vim.g.neovide_text_contrast = 0.1
	vim.g.neovide_padding_left = 10
	vim.g.neovide_padding_top = 10
	vim.opt.linespace = 3
	-- 	vim.g.neovide_cursor_vfx_mode = "torpedo"
	-- 	vim.g.neovide_cursor_vfx_mode = "pixiedust"
end

vim.g.mapleader = S.nvim.leader.mapleader
vim.g.maplocalleader = S.nvim.leader.maplocalleader

function M.toggle_diagnostics()
	vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end

function M.show_cursor_position()
	local cursor_row, cursor_col = unpack(vim.api.nvim_win_get_cursor(0))
require("scripts/sys/notify").send(
			"Row: " .. tostring(cursor_row) .. ", " ..
			"Col: " .. tostring(cursor_col)
		)
end

function M.show_file_status()
	local file_path = vim.fn.fnamemodify(vim.fn.expand('%'), ':~')
	local modified = vim.bo.modified and ' [modified]' or ''
	local msg = file_path .. modified
	require("scripts/sys/notify").send(msg)
end

function M.adjust_neovide_scale(delta)
	vim.g.neovide_scale_factor = vim.g.neovide_scale_factor + delta
end

function M.open_terminal(command)
	vim.cmd("terminal " .. command)
end

function M.oil_files_to_quickfix()
	if vim.bo.filetype ~= 'oil' then return end
	local oil = require 'oil'
	local dir = oil.get_current_dir()

	local entries = {}
	for i = 1, vim.fn.line '$' do
		local entry = oil.get_entry_on_line(0, i)
		if entry and entry.type == 'file' then
			table.insert(entries, { filename = dir .. entry.name })
		end
	end
	if #entries == 0 then return end

	vim.fn.setqflist(entries)
	return vim.cmd.copen()
end

M.oil_keymaps = {
	["H"] = { "actions.parent", mode = "n" },
	["L"] = { "actions.select", mode = "n" },
	["e"] = { "actions.select", opts = { close = false, vertical = true }, mode = "n" },
	["E"] = { "actions.select", opts = { close = false, horizontal = true }, mode = "n" },
	["<Tab>"] = { "actions.preview", mode = "n" },
	['<C-q>'] = M.oil_files_to_quickfix,
	["zo"] = { "actions.open_external", mode = "n" },
	["zy"] = { "actions.yank_entry", mode = "n" },
	["zz"] = { "actions.open_terminal", mode = "n" },
	["zh"] = { "actions.toggle_hidden", mode = "n" },
}

vim.keymap.set("n", "U", "<c-r>")
vim.cmd.tnoremap("<Esc>", "<C-\\><C-n>")

local smart_splits = require('smart-splits')
local split_keymaps = {
	['<A-Left>'] = smart_splits.resize_left,
	['<A-Down>'] = smart_splits.resize_down,
	['<A-Up>'] = smart_splits.resize_up,
	['<A-Right>'] = smart_splits.resize_right,
	['<Left>'] = smart_splits.move_cursor_left,
	['<Down>'] = smart_splits.move_cursor_down,
	['<Up>'] = smart_splits.move_cursor_up,
	['<Right>'] = smart_splits.move_cursor_right,
	['<C-\\>'] = smart_splits.move_cursor_previous,
	['<leader><Left>'] = smart_splits.swap_buf_left,
	['<leader><Down>'] = smart_splits.swap_buf_down,
	['<leader><Up>'] = smart_splits.swap_buf_up,
	['<leader><Right>'] = smart_splits.swap_buf_right,
}

for key, func in pairs(split_keymaps) do
	vim.keymap.set('n', key, func)
end

local leader_keymaps = {
	e = vim.cmd.Oil,
	w = function() M.open_terminal("hilbish -C ~/.aquamoon/terminal.lua --") end,
	q = vim.cmd.bd,
	d = M.toggle_diagnostics,
	c = M.show_cursor_position,
	v = M.show_file_status,
	i = vim.lsp.buf.hover,
	h = function() vim.cmd "LazyGitFilterCurrentFile" end,
	j = function() M.adjust_neovide_scale(-0.1) end,
	k = function() M.adjust_neovide_scale(0.1) end,
	l = function() require "chainsaw".variableLog() end,
	L = function() require "chainsaw".removeLogs() end,
	["/"] = vim.cmd.noh,
}

for key, func in pairs(leader_keymaps) do
	vim.keymap.set({ "n", "x", "o" }, "<leader>" .. key, func)
end

local function_keymaps = {
	[1] = function() vim.cmd "LazyGit" end,
	[2] = vim.cmd.aqua_save,
	[3] = function() vim.cmd.split "./" end,
	[4] = function() vim.cmd.vsplit "./" end,
	[5] = "<Plug>(CybuPrev)",
	[6] = "<Plug>(CybuNext)",
	[7] = function() require("snipe").open_buffer_menu() end,
	[8] = vim.cmd.aqua_run,
}

for cmd, func in pairs(function_keymaps) do
	vim.keymap.set({ "n", "i" }, "<F" .. cmd .. ">", func)
end

require("mini.hipatterns").setup({
	highlighters = S.nvim.plugins.hipatterns,
})

local starter = require('mini.starter')
require("mini.starter").setup({
	header = "",
	footer = "",
	evaluate_single = true,
	items = {
		starter.sections.recent_files(S.nvim.plugins.starter.recent_files_count, false),
	},
	content_hooks = {
		starter.gen_hook.aligning('center', 'top'),
		starter.gen_hook.padding(unpack(S.nvim.plugins.starter.padding)),
		starter.gen_hook.adding_bullet(vim.flag .. " "),
	},
})

for _, plug in pairs(S.nvim.plugins.unconfigured_mini) do
	require("mini." .. plug).setup()
end

function _G.get_oil_winbar()
	local bufnr = vim.api.nvim_win_get_buf(vim.g.statusline_winid)
	local dir = require("oil").get_current_dir(bufnr)
	if dir then
		return " " .. vim.flag .. " " .. vim.fn.fnamemodify(dir, ":~")
	else
		return " " .. vim.flag .. " " .. vim.api.nvim_buf_get_name(0)
	end
end

local oil_config = {
	watch_for_changes = true,
	use_default_keymaps = false,
	keymaps = M.oil_keymaps,
	columns = {
		"icon",
		"size"
	},
}

if S.theme_name == "moonfly" then
	oil_config.win_options = {
		winbar = "%!v:lua.get_oil_winbar()",
	}
end

require "oil".setup(oil_config)
require "chainsaw".setup()
require "cybu".setup()
require "bluloco".setup({ transparent = true, italics = true })
require "mfd".setup({ accessibility_contrast = 5 })

require "tv".setup({
	channels = S.nvim.plugins.tv.channels,
	window = {
		width = 1,
		height = 1,
	}
})

require "snipe".setup({
	ui = {
		position = S.nvim.plugins.snipe.position,
		text_align = S.nvim.plugins.snipe.text_align,
		open_win_override = {
			title = vim.flag,
			border = "rounded"
		}
	},
	navigate = S.nvim.plugins.snipe.navigate
})

local cling_wrappers = S.nvim.plugins.cling.wrappers
local wrappers_list = {}
for i = 1, 20 do
	if cling_wrappers[tostring(i)] then
		table.insert(wrappers_list, cling_wrappers[tostring(i)])
	end
end
require("cling").setup({ wrappers = wrappers_list })

return M
