-- AUTOCOMMANDS
-- TODO toggle cursorline on InsertEnter and InsertLeave
vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function() vim.hl.on_yank({ higroup = "LineNr", timeout = 250 }) end,
})
vim.api.nvim_create_autocmd("BufEnter", {
	pattern = { "*.jpg", "*.png" },
	callback = function()
		vim.cmd([[ terminal timg % ]])
	end
})
vim.api.nvim_create_autocmd("BufEnter", {
	pattern = { "*.js", "*.gd", "*.lua", "*.md" },
	callback = function()
		vim.treesitter.start()
	end
})
vim.api.nvim_create_autocmd("BufEnter", {
	pattern = { "*.js", "*.lua" },
	callback = function()
		require("mini.completion").setup()
	end,
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
	callback = function()
		-- check for file changes when leaving the terminal
		vim.cmd.checktime()
	end
})
-- TODO
-- on open fzf:
-- vim.b.minicompletion_disable = true
