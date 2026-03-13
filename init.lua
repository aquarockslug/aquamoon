local vim = vim

-- BOOTSTRAP ROCKS.NVIM
do
	-- Specifies where to install/use rocks.nvim
	local install_location = vim.fs.joinpath(vim.fn.stdpath("data") --[[@as string]], "rocks")

	-- Set up configuration options related to rocks.nvim (recommended to leave as default)
	local rocks_config = {
		rocks_path = vim.fs.normalize(install_location),
	}

	vim.g.rocks_nvim = rocks_config

	-- Configure the package path (so that plugin code can be found)
	local luarocks_path = {
		vim.fs.joinpath(rocks_config.rocks_path, "share", "lua", "5.1", "?.lua"),
		vim.fs.joinpath(rocks_config.rocks_path, "share", "lua", "5.1", "?", "init.lua"),
	}
	package.path = package.path .. ";" .. table.concat(luarocks_path, ";")

	-- Configure the C path (so that e.g. tree-sitter parsers can be found)
	local luarocks_cpath = {
		vim.fs.joinpath(rocks_config.rocks_path, "lib", "lua", "5.1", "?.so"),
		vim.fs.joinpath(rocks_config.rocks_path, "lib64", "lua", "5.1", "?.so"),
	}
	package.cpath = package.cpath .. ";" .. table.concat(luarocks_cpath, ";")

	-- Add rocks.nvim to the runtimepath
	vim.opt.runtimepath:append(vim.fs.joinpath(rocks_config.rocks_path, "lib", "luarocks", "rocks-5.1", "rocks.nvim",
		"*"))
end
-- If rocks.nvim is not installed then install it!
if not pcall(require, "rocks") then
	local rocks_location = vim.fs.joinpath(vim.fn.stdpath("cache") --[[@as string]], "rocks.nvim")

	if not vim.uv.fs_stat(rocks_location) then
		-- Pull down rocks.nvim
		local url = "https://github.com/lumen-oss/rocks.nvim"
		vim.fn.system({ "git", "clone", "--filter=blob:none", url, rocks_location })
		-- Make sure the clone was successfull
		assert(vim.v.shell_error == 0, "rocks.nvim installation failed. Try exiting and re-entering Neovim!")
	end

	-- If the clone was successful then source the bootstrapping script
	vim.cmd.source(vim.fs.joinpath(rocks_location, "bootstrap.lua"))

	vim.fn.delete(rocks_location, "rf")
end


-- NEOVIM CONFIGURATION FOR AQUAMOON
local vim = vim -- avoid undefined warnings
S = dofile(os.getenv("HOME") .. "/.aquamoon/settings.lua")
package.path = package.path .. '/home/aqua/.aquamoon/?.lua;/home/aqua/.aquamoon/?/?.lua;;'


-- GLOBAL VARIABLES
vim.g.godot_executable = "/bin/godot3"
vim.g.lazygit_floating_window_scaling_factor = 1
vim.g.lazygit_floating_window_border_chars = { '', '', '', '', '', '', '', '' } -- remove border
vim.flag = "󰈿"

-- SAVE
vim.cmd.aqua_save = function()
	-- avoid warnings from oil and ministart filetype
	if vim.bo.filetype ~= "oil" and vim.bo.filetype ~= "ministarter" then
		MiniTrailspace.trim()
		vim.lsp.buf.format()
		require("scripts/notify").send(require('lsp-status').status())
	end

	vim.cmd "silent write"
end


-- RUN
vim.cmd.aqua_run = function()
	if vim.bo.filetype == 'gdscript' then
		require("fidget").notify("RUN")
		os.execute(vim.g.godot_executable .. " --upwards " .. vim.fn.expand('%:p:f'))
	end
end


-- AUTOCOMMANDS
vim.api.nvim_create_autocmd("InsertEnter", {
	callback = function()
		vim.opt.cursorline = false
	end,
})
vim.api.nvim_create_autocmd("InsertLeave", {
	callback = function()
		vim.opt.cursorline = true
	end,
})
vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function() vim.hl.on_yank({ higroup = "LineNr", timeout = 250 }) end,
})
vim.api.nvim_create_autocmd("BufEnter", {
	pattern = { "*.jpg", "*.png", "*.ico" },
	callback = function()
		vim.cmd([[ terminal chafa % ]])
	end
})
vim.api.nvim_create_autocmd("BufEnter", {
	pattern = { "*.js", "*.gd", "*.lua", "*.md" },
	callback = function()
		vim.treesitter.start()
	end
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
	desc = "check for file changes when leaving the terminal",
	callback = function()
		vim.cmd.checktime()
	end
})


-- HIGHLIGHTS
local theme = S.theme
local highlights = {
	LineNr = { bg = theme.bg, fg = theme.fg },
	LineNrAbove = { fg = theme.fg },
	LineNrBelow = { fg = theme.fg },
	CursorLineNr = { fg = theme.fg },
	OilDir = { fg = theme.fg },
	LazyGitFloat = { fg = theme.fg2 },
	LazyGitBorder = { fg = theme.fg },
	MiniStarterSection = { fg = theme.fg },
	MiniStarterItemPrefix = { fg = theme.accent },
	MiniStarterQuery = { fg = theme.accent },
	Cursor = { bg = theme.fg, fg = theme.bg },
	lCursor = { bg = theme.fg, fg = theme.bg },
	CursorIM = { bg = theme.accent, fg = theme.bg },
}

for group, colors in pairs(highlights) do
	local attrs = {}
	if colors.bg then table.insert(attrs, "guibg=#" .. colors.bg) end
	if colors.fg then table.insert(attrs, "guifg=#" .. colors.fg) end
	vim.cmd.highlight(group .. " " .. table.concat(attrs, " "))
end


-- NEOVIDE CONFIGURATION
if vim.g.neovide then
	vim.g.neovide_opacity = S.theme.opacity
	vim.o.guifont = S.theme.active_font.name
	vim.g.neovide_text_gamma = 0.8
	vim.g.neovide_text_contrast = 0.1
	vim.g.neovide_padding_left = 10
	vim.g.neovide_padding_top = 10
	vim.opt.linespace = 3

	if S.theme_name == "OceanicNext" or S.theme_name == "minicyan" then
		vim.g.neovide_cursor_vfx_mode = "torpedo"
	end
	if S.theme_name == "srcery" or S.theme_name == "eldritch" then
		vim.g.neovide_cursor_vfx_mode = "pixiedust"
	end
end



-- require the other aquamoon nvim config files
require "nvim_mappings"; require "nvim_plugins";
