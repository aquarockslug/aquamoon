-- NEOVIM CONFIGURATION FOR AQUAMOON
package.path = package.path .. '/home/aqua/.aquamoon/?.lua;/home/aqua/.aquamoon/?/?.lua;;'
local vim = vim -- avoid undefined warnings
S = require "settings"
require "nvim/rocks"
require "neomodern".setup({ theme = "iceclimber", code_style = { comments = "italic" } })
require "leap".setup({})


-- GLOBAL VARIABLES
vim.g.mapleader = ","
vim.g.maplocalleader = ","
vim.g.godot_executable = "/bin/godot3"
vim.g.lazygit_floating_window_scaling_factor = 1
vim.g.lazygit_floating_window_border_chars = { '', '', '', '', '', '', '', '' } -- remove border
vim.g.oceanic_next_terminal_bold = 1
vim.g.oceanic_next_terminal_italic = 1
vim.flag = "󰈿"


-- LANGUAGE SERVERS
local lspconfig = require('lspconfig')
lspconfig.biome.setup({})
lspconfig.lua_ls.setup({})
lspconfig.vale_ls.setup({})
lspconfig.gdscript.setup({})


-- DIAGNOSTICS
vim.diagnostic.config({
	signs = false,
	virtual_lines = true
})
vim.diagnostic.enable(false)


-- SAVE
save = function()
	-- prevent oil warning
	if vim.bo.filetype ~= "oil" and vim.bo.filetype ~= "ministarter" then
		MiniTrailspace.trim()
		vim.lsp.buf.format()
		if #vim.lsp.buf_get_clients() > 0 then
			-- TODO dont show "Notifications" part
			-- TODO vim.o.statusline = require('lsp-status').status()
			require("fidget").notify(require('lsp-status').status())
		else
			require("fidget").notify("SAVED")
		end
	end

	vim.cmd "silent write"
end


-- RUN
run = function()
	if vim.bo.filetype == 'gdscript' then
		require("fidget").notify("RUN")
		os.execute(vim.g.godot_executable .. " --upwards " .. vim.fn.expand('%:p:f'))
	end
end


-- SNIPE
require("snipe").setup({
	ui = {
		position = "center",
		text_align = "file-first",
		open_win_override = {
			title = vim.flag,
			border = "rounded"
		}
	},
	navigate = { open_vsplit = "e", open_split = "E" }
})


-- TELEVISION
require("tv").setup({
	keybindings = {
		files = "<leader>f",
		text = "<leader>g",
		channels = "<leader>m",
	},
	window = {
		width = 1.0,
		height = 1.0,
	}
})


-- NEOVIDE
if vim.g.neovide then
	vim.g.neovide_opacity = S.theme.opacity
	vim.o.guifont = S.theme.active_font.name
	vim.g.neovide_text_gamma = 0.8
	vim.g.neovide_text_contrast = 0.1
	vim.g.neovide_padding_left = 10
	vim.g.neovide_padding_top = 10

	-- set vfx mode depending on the current theme
	if S.theme_name == "OceanicNext" or S.theme_name == "minicyan" then
		vim.g.neovide_cursor_vfx_mode = "torpedo"
	end
	if S.theme_name == "srcery" or S.theme_name == "eldritch" then
		vim.g.neovide_cursor_vfx_mode = "pixiedust"
	end
end


-- require the other aquamoon nvim config files
require "nvim/mini"; require "nvim/oil";
require "nvim/autocmds"; require "nvim/highlights";
require "nvim/keymap"; require "nvim/terminal";
