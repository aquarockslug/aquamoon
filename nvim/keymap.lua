-- KEYMAP
local vim = vim

-- navigate nvim windows using arrow keys
vim.keymap.set("n", "<Left>", "<c-w>h")
vim.keymap.set("n", "<Right>", "<c-w>l")
vim.keymap.set("n", "<Down>", "<c-w>j")
vim.keymap.set("n", "<Up>", "<c-w>k")

-- redo
vim.keymap.set("n", "U", "<c-r>")

-- exit terminal with Esc
vim.cmd.tnoremap("<Esc>", "<C-\\><C-n>")


vim.cmd.toggle_diagnostics = function() -- toggle diagnostics
	vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end

for key, func in pairs({
	-- left hand top row
	e = vim.cmd.Oil,
	w = vim.cmd.terminal,
	q = vim.cmd.bd,

	-- left hand home row
	g = FzfLua.live_grep,
	f = FzfLua.files,
	d = vim.cmd.toggle_diagnostics,

	-- left hand lower
	r = function() vim.cmd "terminal scooter" end,
	c = FzfLua.diagnostics_document,
	x = FzfLua.lsp_finder,

	-- right hand top
	i = vim.lsp.buf.hover,
	o = FzfLua.oldfiles,

	-- right hand bottom
	m = function() vim.cmd "FzfLua" end,
	["/"] = vim.cmd.noh
}) do
	vim.keymap.set("n", "<leader>" .. key, func)
end

for cmd, func in pairs({
	-- right hand
	[1] = function() vim.cmd "LazyGit" end,
	[2] = function()
		MiniTrailspace.trim()
		-- prevent oil warning
		if vim.o.filetype ~= "oil" then
			vim.lsp.buf.format()
		end
		vim.cmd.write()
	end,
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
