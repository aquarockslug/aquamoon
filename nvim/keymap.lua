-- KEYMAP
local vim = vim

vim.keymap.set({ "n", "x", "o" }, "<CR>", "<Plug>(leap)")

vim.keymap.set("n", "U", "<c-r>")        -- redo

vim.cmd.tnoremap("<Esc>", "<C-\\><C-n>") -- exit terminal with Esc

vim.cmd.toggle_diagnostics = function()
	vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end

require('smart-splits').setup()
vim.keymap.set('n', '<A-Left>', require('smart-splits').resize_left)
vim.keymap.set('n', '<A-Down>', require('smart-splits').resize_down)
vim.keymap.set('n', '<A-Up>', require('smart-splits').resize_up)
vim.keymap.set('n', '<A-Right>', require('smart-splits').resize_right)
vim.keymap.set('n', '<Left>', require('smart-splits').move_cursor_left)
vim.keymap.set('n', '<Down>', require('smart-splits').move_cursor_down)
vim.keymap.set('n', '<Up>', require('smart-splits').move_cursor_up)
vim.keymap.set('n', '<Right>', require('smart-splits').move_cursor_right)
vim.keymap.set('n', '<C-\\>', require('smart-splits').move_cursor_previous)
vim.keymap.set('n', '<leader><Left>', require('smart-splits').swap_buf_left)
vim.keymap.set('n', '<leader><Down>', require('smart-splits').swap_buf_down)
vim.keymap.set('n', '<leader><Up>', require('smart-splits').swap_buf_up)
vim.keymap.set('n', '<leader><Right>', require('smart-splits').swap_buf_right)

for key, func in pairs({
	-- left hand top row
	r = function() vim.cmd "terminal scooter" end,
	e = vim.cmd.Oil,
	w = vim.cmd.terminal,
	q = vim.cmd.bd,

	-- left hand home row
	d = vim.cmd.toggle_diagnostics,

	-- left hand lower
	c = function()
		local cursor_row, cursor_col = unpack(vim.api.nvim_win_get_cursor(0))
		require("fidget").notify(
			"Row: " .. tostring(cursor_row) .. ", " ..
			"Col: " .. tostring(cursor_col)
		)
	end,

	-- right hand top
	y = function() vim.cmd "terminal clipse" end,
	i = vim.lsp.buf.hover,
	o = function() vim.cmd "terminal opencode" end,

	-- right hand center
	h = function() vim.cmd "LazyGitFilterCurrentFile" end,
	j = function() vim.g.neovide_scale_factor = vim.g.neovide_scale_factor - 0.1 end,
	k = function() vim.g.neovide_scale_factor = vim.g.neovide_scale_factor + 0.1 end,

	-- right hand bottom
	n = function() vim.cmd "terminal wiremix" end,
	["/"] = vim.cmd.noh
}) do
	vim.keymap.set({ "n", "x", "o" }, "<leader>" .. key, func)
end

for cmd, func in pairs({
	-- right hand
	[1] = function() vim.cmd "LazyGit" end,
	[2] = vim.cmd.aqua_save, -- from init.lua
	[3] = function() vim.cmd.split "./" end,
	[4] = function() vim.cmd.vsplit "./" end,
	-- left hand
	[5] = vim.cmd.cprev,
	[6] = vim.cmd.cnext,
	[7] = function() require("snipe").open_buffer_menu() end,
	[8] = vim.cmd.aqua_run, -- from init.lua
}) do
	vim.keymap.set({ "n", "i" }, "<F" .. cmd .. ">", func)
end
