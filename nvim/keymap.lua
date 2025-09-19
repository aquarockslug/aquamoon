-- KEYMAP
local vim = vim

-- navigate nvim windows using arrow keys
vim.keymap.set("n", "<Left>", "<c-w>h")
vim.keymap.set("n", "<Right>", "<c-w>l")
vim.keymap.set("n", "<Down>", "<c-w>j")
vim.keymap.set("n", "<Up>", "<c-w>k")

-- left hand top row
vim.keymap.set("n", "<leader>r", vim.lsp.buf.hover)
vim.keymap.set("n", "<leader>e", function() require("oil").open() end)
vim.keymap.set("n", "<leader>w", function() vim.cmd "terminal" end)
vim.keymap.set("n", "<leader>q", vim.cmd.bd) -- buffer delete

-- left hand home row
vim.keymap.set("n", "<leader>g", vim.cmd.GrugFar)
vim.keymap.set("n", "<leader>G", function() Snacks.terminal("glow --pager " .. vim.fn.expand('%:p')) end)
vim.keymap.set("n", "<leader>f", function() Snacks.picker.smart() end)
vim.keymap.set("n", "<leader>d", function() Snacks.toggle.diagnostics():toggle() end)
vim.keymap.set("n", "<leader>S", function() Snacks.picker.spelling() end)
vim.keymap.set("n", "<leader>s", function() Snacks.picker.lsp_symbols() end)

-- left hand bottom
vim.keymap.set("n", "<leader>z", function() Snacks.zen() end)

-- right hand top
vim.keymap.set("n", "U", "<c-r>")

-- right hand bottom
vim.keymap.set("n", "<leader>m", function() Snacks.picker() end)
vim.keymap.set("n", "<leader>/", vim.cmd.noh) -- clear highlighting

-- exit terminal with Esc
vim.cmd.tnoremap("<Esc>", "<C-\\><C-n>")

for cmd, func in pairs({
	-- right hand
	[1] = function() Snacks.lazygit.open() end,
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
