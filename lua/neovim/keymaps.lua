local M = {}

function M.setup()
	local map = vim.keymap.set
	map("n", "<leader>/", ":noh<CR>")
	map("n", "<leader>l", function()
		vim.cmd.split()
		vim.cmd.Oil()
	end)
	map("n", "<leader>;", function()
		vim.cmd.vsplit()
		vim.cmd.Oil()
	end)
	for key, command in pairs({ Left = "<C-w>h", Down = "<C-w>j", Up = "<C-w>k", Right = "<C-w>l" }) do
		map("n", "<" .. key .. ">", command)
	end
	map("n", "U", "<C-r>")
end

return M
