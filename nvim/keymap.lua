-- KEYMAP
local vim = vim

-- navigate nvim windows using arrow keys
vim.keymap.set("n", "<Left>", "<c-w>h")
vim.keymap.set("n", "<Right>", "<c-w>l")
vim.keymap.set("n", "<Down>", "<c-w>j")
vim.keymap.set("n", "<Up>", "<c-w>k")

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
	g = FzfLua.grep_project,
	f = FzfLua.files,
	d = vim.cmd.toggle_diagnostics,
	s = FzfLua.spellcheck,

	-- left hand lower
	c = FzfLua.diagnostics_document,
	x = FzfLua.lsp_finder,

	-- right hand top
	y = function() vim.cmd "terminal youtui" end,
	i = vim.lsp.buf.hover,
	o = FzfLua.oldfiles,
	p = function() vim.cmd "terminal opencode" end,

	-- right hand bottom
	m = function() vim.cmd "FzfLua" end,
	["/"] = vim.cmd.noh
}) do
	vim.keymap.set("n", "<leader>" .. key, func)
end

for cmd, func in pairs({
	-- right hand
	[1] = function() vim.cmd "LazyGit" end,
	[2] = vim.cmd.save,
	[3] = function() vim.cmd.split("./") end,
	[4] = function() vim.cmd.vsplit("./") end,
	-- left hand
	[5] = vim.cmd.bnext,
	[6] = vim.cmd.bprev,
	[7] = function() require("snipe").open_buffer_menu() end,
}) do
	vim.keymap.set("i", "<F" .. cmd .. ">", func)
	vim.keymap.set("n", "<F" .. cmd .. ">", func)
end
