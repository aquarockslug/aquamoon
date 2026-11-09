local M = {}

function M.setup()
	vim.g.mapleader = ","

	vim.fn.setenv("STARSHIP_CONFIG", vim.fn.expand("~/.aquamoon/toml/starship.toml"))

	-- Starship is a prompt, not a shell. Use bash for :terminal and :!, and let
	-- ~/.bashrc run `starship init bash` for interactive shells.
	local bash = vim.fn.exepath("bash")
	if bash ~= "" then
		vim.opt.shell = bash
	end

	vim.o.termguicolors = true
	vim.o.clipboard = "unnamedplus"
end

return M
