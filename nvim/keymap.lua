-- KEYMAP
local vim = vim

-- navigate nvim windows using arrow keys
vim.keymap.set("n", "<Left>", "<c-w>h")
vim.keymap.set("n", "<Right>", "<c-w>l")
vim.keymap.set("n", "<Down>", "<c-w>j")
vim.keymap.set("n", "<Up>", "<c-w>k")

vim.keymap.set({ "n", "x", "o" }, "<CR>", "<Plug>(leap)")

vim.keymap.set("n", "U", "<c-r>")        -- redo

vim.cmd.tnoremap("<Esc>", "<C-\\><C-n>") -- exit terminal with Esc

vim.cmd.toggle_diagnostics = function()
	vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end

for key, func in pairs({
	-- left hand top row
	r = function() vim.cmd "terminal scooter" end,
	e = vim.cmd.Oil,
	w = vim.cmd.terminal,
	q = vim.cmd.bd,

	-- left hand home row
	d = vim.cmd.toggle_diagnostics,
	-- f = tv files, defined in tv setup
	-- g = tv text

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
