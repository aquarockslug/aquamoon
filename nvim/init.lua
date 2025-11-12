-- NEOVIM CONFIGURATION FOR AQUAMOON
package.path = '/home/aqua/.aquamoon/?.lua;/home/aqua/.aquamoon/?/?.lua;;'

local rocks_config = {
	rocks_path = vim.env.HOME .. "/.local/share/nvim/rocks",
}

vim.g.rocks_nvim = rocks_config

local luarocks_path = {
	vim.fs.joinpath(rocks_config.rocks_path, "share", "lua", "5.1", "?.lua"),
	vim.fs.joinpath(rocks_config.rocks_path, "share", "lua", "5.1", "?", "init.lua"),
}
package.path = package.path .. ";" .. table.concat(luarocks_path, ";")

local luarocks_cpath = {
	vim.fs.joinpath(rocks_config.rocks_path, "lib", "lua", "5.1", "?.so"),
	vim.fs.joinpath(rocks_config.rocks_path, "lib64", "lua", "5.1", "?.so"),
	-- Remove the dylib and dll paths if you do not need macos or windows support
	vim.fs.joinpath(rocks_config.rocks_path, "lib", "lua", "5.1", "?.dylib"),
	vim.fs.joinpath(rocks_config.rocks_path, "lib64", "lua", "5.1", "?.dylib"),
	vim.fs.joinpath(rocks_config.rocks_path, "lib", "lua", "5.1", "?.dll"),
	vim.fs.joinpath(rocks_config.rocks_path, "lib64", "lua", "5.1", "?.dll"),
}
package.cpath = package.cpath .. ";" .. table.concat(luarocks_cpath, ";")

vim.opt.runtimepath:append(vim.fs.joinpath(rocks_config.rocks_path, "lib", "luarocks", "rocks-5.1", "rocks.nvim", "*"))

local settings = require "settings"
local vim = vim -- avoid undefined warnings

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


-- FZF
require("fzf-lua").setup({
	winopts = { height = 1.0, width = 1.0 },
	hls = { border = "LineNr" }
})

-- TELEVISION
require("tv").setup({
	keybindings = {
		files = "<leader>f",
		text = "<leader>g",
		channels = "<leader>m",
		-- files_qf = "<leader>q",
		-- text_qf = "<leader>a",
  	},
	window = {
		width = 1.0,
	  	height = 1.0,
  	}
})


-- NEOVIDE
if vim.g.neovide then
	vim.g.neovide_opacity = settings.theme.opacity
	vim.o.guifont = settings.theme.active_font.name
	vim.g.neovide_text_gamma = 0.8
	vim.g.neovide_text_contrast = 0.1
	vim.g.neovide_padding_left = 10
	vim.g.neovide_padding_top = 10

	-- set vfx mode depending on the current theme
	if settings.theme_name == "OceanicNext" then
		vim.g.neovide_cursor_vfx_mode = "torpedo"
	end
	if settings.theme_name == "srcery" then
		vim.g.neovide_cursor_vfx_mode = "pixiedust"
	end
	-- if settings.theme_name == "moonfly" then
	-- 	vim.g.neovide_cursor_vfx_mode = "wireframe"
	-- end
end


-- OIL
-- Declare a global function to retrieve the current directory
function _G.get_oil_winbar()
	local bufnr = vim.api.nvim_win_get_buf(vim.g.statusline_winid)
	local dir = require("oil").get_current_dir(bufnr)
	if dir then
		return " " .. vim.flag .. " " .. vim.fn.fnamemodify(dir, ":~")
	else
		return " " .. vim.flag .. " " .. vim.api.nvim_buf_get_name(0)
	end
end

local oil_config = {
	watch_for_changes = true,
	use_default_keymaps = false,
	keymaps = {
		["H"] = { "actions.parent", mode = "n" },
		["L"] = { "actions.select", mode = "n" },
		["e"] = { "actions.select", opts = { close = false, vertical = true }, mode = "n" },
		["E"] = { "actions.select", opts = { close = false, horizontal = true }, mode = "n" },
		["<Tab>"] = { "actions.preview", mode = "n" }, -- TODO shows an error on image preview

		-- "z" is like the <leader> for Oil
		["zo"] = { "actions.open_external", mode = "n" },
		["zy"] = { "actions.yank_entry", mode = "n" },
		["zz"] = { "actions.open_terminal", mode = "n" },
		["zh"] = { "actions.toggle_hidden", mode = "n" },
	},
	columns = {
		"icon",
		"size"
	},
}
-- only add win_options if using a colorscheme that supports winbar
if settings.theme_name == "minicyan" or settings.theme_name == "moonfly" then
	oil_config.win_options = {
		winbar = "%!v:lua.get_oil_winbar()",
	}
end
require "oil".setup(oil_config)

require "neomodern".setup({ theme = "iceclimber", code_style = { comments = "italic" } })

require "leap".setup({})
vim.keymap.set({'n', 'x', 'o'}, '<CR>', '<Plug>(leap)')

-- require the other aquamoon nvim config files
require "nvim/mini"
require "nvim/autocmds"; require "nvim/highlights";
require "nvim/keymap"; require "nvim/terminal";
