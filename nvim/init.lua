package.path = package.path .. '/home/aqua/.aquamoon/?.lua;/home/aqua/.aquamoon/?/?.lua;;'

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
S = require "settings"


-- GLOBAL VARIABLES
vim.g.mapleader = ","
vim.g.maplocalleader = ","
vim.g.godot_executable = "/bin/godot3"
vim.g.lazygit_floating_window_scaling_factor = 1
vim.g.lazygit_floating_window_border_chars = { '', '', '', '', '', '', '', '' } -- remove border
vim.g.oceanic_next_terminal_bold = 1
vim.g.oceanic_next_terminal_italic = 1
vim.flag = "󰈿"


-- PLUGINS
require "nvim/rocks"
require "neomodern".setup({ theme = "iceclimber", code_style = { comments = "italic" } })
require "debugprint".setup({
	-- keymaps = { normal = { plain_below = "<leader>v", plain_above = "<leader>V" } }
})
require "leap".setup({})
-- define a preview filter to reduce visual noise
require('leap').opts.preview = function(ch0, ch1, ch2)
	return not (
		ch1:match('%s')
		or (ch0:match('%a') and ch1:match('%a') and ch2:match('%a'))
	)
end
require('leap').opts.equivalence_classes = {
	' \t\r\n', '([{', ')]}', '\'"`'
}
require "tv".setup({
	channels = {
		files = {
			keybinding = '<leader>f', -- Launch the files channel
		},
		text = {
			keybinding = '<leader>g',
		},
	},
})
require "snipe".setup({
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
vim.cmd.tnoremap("<Esc>", "<C-\\><C-n>") -- exit terminal with Esc


-- SAVE
vim.cmd.aqua_save = function()
	-- avoid warnings from oil and ministart filetype
	if vim.bo.filetype ~= "oil" and vim.bo.filetype ~= "ministarter" then
		MiniTrailspace.trim()
		vim.lsp.buf.format()
		if #vim.lsp.buf.get_clients() > 0 then
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
vim.cmd.aqua_run = function()
	if vim.bo.filetype == 'gdscript' then
		require("fidget").notify("RUN")
		os.execute(vim.g.godot_executable .. " --upwards " .. vim.fn.expand('%:p:f'))
	end
end


-- NEOVIDE
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


-- require the other aquamoon nvim config files
require "nvim/mini"; require "nvim/oil";
require "nvim/autocmds"; require "nvim/highlights";
require "nvim/keymap"; require "nvim/terminal";
