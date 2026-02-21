-- KEYMAP CONFIGURATION
local vim = vim

-- Utility functions
local M = {}

function M.toggle_diagnostics()
	vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end

function M.show_cursor_position()
	local cursor_row, cursor_col = unpack(vim.api.nvim_win_get_cursor(0))
	require("fidget").notify(
		"Row: " .. tostring(cursor_row) .. ", " ..
		"Col: " .. tostring(cursor_col)
	)
end

function M.adjust_neovide_scale(delta)
	vim.g.neovide_scale_factor = vim.g.neovide_scale_factor + delta
end

function M.open_terminal(command)
	vim.cmd("terminal " .. command)
end

-- keymaps
vim.keymap.set({ "n", "x", "o" }, "<CR>", function() require("leap").leap({ backward = true }) end)
vim.keymap.set("n", "U", "<c-r>")
vim.cmd.tnoremap("<Esc>", "<C-\\><C-n>")

-- Smart splits configuration
local smart_splits = require('smart-splits')
local split_keymaps = {
	-- Window resizing
	['<A-Left>'] = smart_splits.resize_left,
	['<A-Down>'] = smart_splits.resize_down,
	['<A-Up>'] = smart_splits.resize_up,
	['<A-Right>'] = smart_splits.resize_right,

	-- Cursor movement between windows
	['<Left>'] = smart_splits.move_cursor_left,
	['<Down>'] = smart_splits.move_cursor_down,
	['<Up>'] = smart_splits.move_cursor_up,
	['<Right>'] = smart_splits.move_cursor_right,
	['<C-\\>'] = smart_splits.move_cursor_previous,

	-- Buffer swapping
	['<leader><Left>'] = smart_splits.swap_buf_left,
	['<leader><Down>'] = smart_splits.swap_buf_down,
	['<leader><Up>'] = smart_splits.swap_buf_up,
	['<leader><Right>'] = smart_splits.swap_buf_right,
}

for key, func in pairs(split_keymaps) do
	vim.keymap.set('n', key, func)
end

-- Leader keymaps
local leader_keymaps = {
	e = vim.cmd.Oil,
	w = function() M.open_terminal("hilbish -C ~/.aquamoon/terminal.lua --") end,
	q = vim.cmd.bd,
	d = M.toggle_diagnostics,
	c = M.show_cursor_position,
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

-- Function key keymaps
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

return M
