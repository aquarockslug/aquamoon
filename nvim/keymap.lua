-- KEYMAP
local vim = vim

-- navigate nvim windows using arrow keys
vim.keymap.set("n", "<Left>", "<c-w>h")
vim.keymap.set("n", "<Right>", "<c-w>l")
vim.keymap.set("n", "<Down>", "<c-w>j")
vim.keymap.set("n", "<Up>", "<c-w>k")

-- left hand top row
vim.keymap.set("n", "<leader>r", vim.lsp.buf.hover)
vim.keymap.set("n", "<leader>e", vim.cmd.Oil)
vim.keymap.set("n", "<leader>w", vim.cmd.terminal)
vim.keymap.set("n", "<leader>q", vim.cmd.bd) -- buffer delete

-- left hand home row
vim.keymap.set("n", "<leader>g", vim.cmd.GrugFar)
vim.keymap.set("n", "<leader>f", FzfLua.files)
vim.keymap.set("n", "<leader>d", function() -- toggle diagnostics
	vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end)

-- left hand lower
vim.keymap.set("n", "<leader>v", FzfLua.lsp_finder)
vim.keymap.set("n", "<leader>c", FzfLua.diagnostics_document)

-- right hand top
vim.keymap.set("n", "U", "<c-r>")
vim.keymap.set("n", "<leader>o", FzfLua.oldfiles)

-- right hand bottom
vim.keymap.set("n", "<leader>m", function() vim.cmd "FzfLua" end)
vim.keymap.set("n", "<leader>/", vim.cmd.noh) -- clear highlighting

-- exit terminal with Esc
vim.cmd.tnoremap("<Esc>", "<C-\\><C-n>")

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
