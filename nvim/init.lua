-- NEOVIM CONFIGURATION FOR AQUAMOON
package.path = '/home/aqua/.aquamoon/?.lua;/home/aqua/.aquamoon/?/?.lua'
local vim = vim -- avoid undefined warnings

vim.g.mapleader = ","
vim.g.maplocalleader = ","
vim.opt.clipboard = "unnamedplus" -- allows neovim to access the system clipboard
vim.opt.autochdir = true
vim.opt.cmdheight = 0
vim.opt.laststatus = 1
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.scrolloff = 10000
vim.opt.signcolumn = "no"
vim.diagnostic.config({
	signs = false,
	virtual_lines = true
})
vim.flag = "󰈿"

require("nvim/rocks_nvim").setup()

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

-- NEOVIDE
if vim.g.neovide then
	vim.g.neovide_opacity = 0.33
	vim.o.guifont = "BigBlueTermPlus Nerd Font Propo:h12"
	vim.g.neovide_text_gamma = 0.0
	vim.g.neovide_text_contrast = 0.5
	vim.g.neovide_padding_bottom = 1
	-- vim.g.neovide_cursor_vfx_mode = "torpedo"

	-- change scale factor
	vim.g.neovide_scale_factor = 1.0
	local change_scale_factor = function(delta)
		vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * delta
	end
	vim.keymap.set("n", "<C-=>", function()
		change_scale_factor(1.25)
	end)
	vim.keymap.set("n", "<C-->", function()
		change_scale_factor(1 / 1.25)
	end)
end

-- LANGUAGE SERVERS
require("lspconfig")["biome"].setup({})
require("lspconfig")["lua_ls"].setup({})
require("lspconfig")["omnisharp"].setup({ cmd = { "dotnet", "/usr/bin/omnisharp" } })

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

-- OIL
require("oil").setup({
	watch_for_changes = true,
	use_default_keymaps = false,
	keymaps = {
		["q"] = { "actions.close", mode = "n" },
		["h"] = { "actions.parent", mode = "n" },
		["l"] = { "actions.select", mode = "n" },
		["e"] = { "actions.select", opts = { close = false, vertical = true }, mode = "n" },
		["E"] = { "actions.select", opts = { close = false, horizontal = true }, mode = "n" },
		["zh"] = { "actions.toggle_hidden", mode = "n" },
		["<Tab>"] = { "actions.preview", mode = "n" }, -- TODO shows an error on image preview
	},
	columns = {
		"icon",
		"size"
	},
	-- TODO winbar is the wrong color
	win_options = {
		-- winbar = "%!v:lua.get_oil_winbar()",
	},
})

-- THEME
function Setup_Theme()
	local themes = {
		"nightfall",
		"everforest",
		"desert",
		"habamax",
		"tokyonight",
		"dracula"
	}
	-- divide the day into parts and choose a theme based on the current hour
	local theme_index = math.ceil(1 + tonumber(os.date("%H")) / #themes)
	vim.cmd.colorscheme(themes[theme_index])

	require("colorful-winsep").setup({
		hi = {
			bg = "#282A36",
			fg = "#50FA7B",
		},
	})

	local highlights = {
		"Normal",
		"LineNr",
		"Folded",
		"NonText",
		"SpecialKey",
		"VertSplit",
		"SignColumn",
		"EndOfBuffer",
		"Terminal",
		"TablineFill"
	}
	for _, name in pairs(highlights) do
		vim.cmd.highlight(name .. ' guibg=none ctermbg=none')
	end
end

-- KEYMAP
function Setup_Keymap()
	-- navigate nvim windows using arrow keys
	vim.keymap.set("n", "<Left>", "<c-w>h")
	vim.keymap.set("n", "<Right>", "<c-w>l")
	vim.keymap.set("n", "<Down>", "<c-w>j")
	vim.keymap.set("n", "<Up>", "<c-w>k")

	-- left hand top row
	vim.keymap.set("n", "<leader>r", vim.lsp.buf.hover)
	vim.keymap.set("n", "<leader>e", function() require("oil").open() end)
	vim.keymap.set("n", "<leader>w", function()
		vim.cmd.bd()
		-- vim.cmd.terminal()
		vim.cmd "terminal"
	end)
	-- vim.keymap.set("n", "<leader>w", function() Snacks.terminal() end) -- TODO delete the current window after opening snacks terminal
	vim.keymap.set("n", "<leader>q", vim.cmd.bd) -- buffer delete

	-- left hand home row
	vim.keymap.set("n", "<leader>g", vim.cmd.GrugFar)
	-- vim.keymap.set("n", "<leader>g", function() Snacks.picker.grep() end)
	-- vim.keymap.set("n", "<leader>G", function() Snacks.terminal("glow --pager " .. vim.fn.expand('%:p')) end)
	vim.keymap.set("n", "<leader>f", function() Snacks.picker.smart() end)
	vim.keymap.set("n", "<leader>d", function()
		Snacks.toggle.diagnostics():toggle()
		require("trouble").toggle({ mode = "diagnostics" })
	end)
	vim.keymap.set("n", "<leader>S", function() Snacks.picker.spelling() end)
	vim.keymap.set("n", "<leader>s", function() Snacks.picker.lsp_symbols() end)
	vim.keymap.set("n", "<leader>z", function() Snacks.zen() end)

	-- right hand top
	vim.keymap.set("n", "U", "<c-r>")

	-- righ hand bottom
	vim.keymap.set("n", "<leader>m", function() Snacks.picker() end)
	vim.keymap.set("n", "<leader>/", vim.cmd.noh) -- clear highlighting

	for cmd, func in pairs({
		-- right hand
		[1] = function() Snacks.lazygit.open() end,
		[2] = function()
			MiniTrailspace.trim()
			if vim.o.filetype ~= "oil" then
				vim.lsp.buf.format()
			end
			vim.cmd.write()
		end,
		[3] = function() vim.cmd.split("./") end,
		[4] = function() vim.cmd.vsplit("./") end,
		-- left hand
		[5] = vim.cmd.bnext,
		[6] = vim.cmd.bprev,
		[7] = function() require("snipe").open_buffer_menu() end,
	}) do
		vim.keymap.set("i", "<F" .. cmd .. ">", func)
		vim.keymap.set("n", "<F" .. cmd .. ">", func)
	end
end

-- AUTOCOMMANDS
function Setup_Autocmd()
	vim.api.nvim_create_autocmd("InsertEnter", {
		callback = function() Snacks.toggle.option("cursorline"):set(true) end,
	})
	vim.api.nvim_create_autocmd("InsertLeave", {
		callback = function() Snacks.toggle.option("cursorline"):set(false) end,
	})
	vim.api.nvim_create_autocmd("TextYankPost", {
		callback = function() vim.highlight.on_yank({ higroup = "DiffAdd", timeout = 250 }) end, -- TODO use a different highlight group?
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
end

-- MINI
for _, plug in ipairs({
	"ai",
	"basics",
	"bracketed",
	"comment",
	"completion",
	"diff",
	"icons",
	"jump",
	"jump2d",
	"pairs",
	"snippets",
	"starter",
	"surround",
	"trailspace",
	"visits",
	"indentscope"
}) do
	require("mini." .. plug).setup()
end
require("mini.indentscope").setup({ symbol = vim.flag, draw = { delay = 300 } }) -- │
require("mini.snippets").setup({ mappings = { jump_next = "<Tab>", jump_prev = "<S-Tab>" } })
require("mini.hipatterns").setup({
	highlighters = {
		WARN = { pattern = "%f[%w]()WARN()%f[%W]", group = "MiniHipatternsWarn" },
		HACK = { pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHipatternsHack" },
		TODO = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
	},
})

-- SNACKS
require("snacks").setup({
	bigfile = { enabled = true },
	notifier = { enabled = true },
	quickfile = { enabled = true },
	scroll = { enabled = true },
	image = { enabled = true },
	lazygit = { win = { position = "float" } },
	styles = {
		terminal = { height = 0.999, width = 0.999, position = "top", backdrop = false },
		notification = { border = "top" }
	}
})


-- DIAGNOSTICS
Snacks.toggle.diagnostics():set(false)
require("trouble").setup({
	auto_close = true,
	auto_refresh = true,
	focus = true,
	win = { position = "right" },
	icons = {
		indent = {
			middle = " ",
			last = " ",
			top = " ",
			ws = "│  ",
		},
	},
	modes = {
		diagnostics = {
			groups = {
				{ "filename", format = "{file_icon} {basename:Title} {count}" },
			},
		},
	},
})

Setup_Theme(); Setup_Keymap(); Setup_Autocmd()
vim.cmd.Oil()
