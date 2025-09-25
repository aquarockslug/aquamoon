-- AUTOCOMMANDS
-- TODO toggle cursorline on InsertEnter and InsertLeave
vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function() vim.highlight.on_yank({ higroup = "LineNr", timeout = 250 }) end,
})
vim.api.nvim_create_autocmd("BufEnter", {
	pattern = { '*.jpg', '*.png' },
	callback = function(ev)
		vim.cmd([[ terminal timg % ]])
	end
})
-- TODO go to mini dashboard when closing Oil?
vim.api.nvim_create_autocmd("VimResized", {
	-- automatically resize windows
	callback = function() vim.cmd("tabdo wincmd =") end
})
vim.api.nvim_create_autocmd({ "TermOpen" }, {
	callback = function()
		vim.wo[0][0].scrolloff = 0
	end
})
vim.api.nvim_create_autocmd({ "TermClose", "TermLeave" }, {
	callback = function()
		vim.cmd.checktime() -- check for file changes when leaving the terminal
	end
})
