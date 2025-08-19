-- AUTOCOMMANDS
vim.api.nvim_create_autocmd("InsertEnter", {
	callback = function() Snacks.toggle.option("cursorline"):set(true) end,
})
vim.api.nvim_create_autocmd("InsertLeave", {
	callback = function() Snacks.toggle.option("cursorline"):set(false) end,
})
vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function() vim.highlight.on_yank({ higroup = "LineNr", timeout = 250 }) end,
})
vim.api.nvim_create_autocmd("BufEnter", {
	pattern = { '*.jpg', '*.png' },
	callback = function(ev)
		vim.cmd([[ terminal timg % ]])
	end
})
vim.api.nvim_create_autocmd("User", {
	pattern = "OilActionsPost",
	callback = function(event)
		if event.data.actions.type == "move" then
			Snacks.rename.on_rename_file(event.data.actions.src_url, event.data.actions.dest_url)
		end
	end,
})
vim.api.nvim_create_autocmd("VimResized", {
	-- automatically resize windows
	callback = function() vim.cmd("tabdo wincmd =") end
})
vim.api.nvim_create_autocmd({ "TermClose", "TermLeave" }, {
	-- check for file changes when leaving the terminal
	callback = function() vim.cmd.checktime() end
})
vim.api.nvim_create_autocmd({ "TermOpen" }, {
	callback = function()
		vim.o.number = true
		vim.wo[0][0].scrolloff = 0
	end
})
