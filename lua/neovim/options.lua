local M = {}

function M.setup()
	local bindings = require("neovim.toml").load("neovim-bindings.toml")
	vim.g.mapleader = bindings.leader or ","
	vim.fn.setenv("STARSHIP_CONFIG", vim.fn.expand("~/.aquamoon/toml/starship.toml"))

	local bash = vim.fn.exepath("bash")
	if bash ~= "" then
		vim.opt.shell = bash
	end

	vim.o.termguicolors = true
	vim.o.clipboard = "unnamedplus"

	vim.filetype.add({
		extension = { lush = "lua" },
		interpreter = { lush = "lua" },
	})
end

return M
