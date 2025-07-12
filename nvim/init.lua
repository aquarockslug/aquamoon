-- NEOVIM CONFIGURATION FOR AQUAMOON

local vim = vim -- avoid undefined warnings

require("nvim/rocks_nvim").setup()

require("smear_cursor").enabled = true
require("snipe").setup({ ui = { position = "center" } })

-- THEME
local currenthour = tonumber(os.date("%H"))

if currenthour >= 8 and currenthour <= 14 then
	vim.cmd [[colorscheme desert]]
	-- vim.cmd [[colorscheme everforest]]
	require("colorful-winsep").setup({})
elseif currenthour > 14 and currenthour <= 20 then
	vim.cmd [[colorscheme habamax]]
	require("colorful-winsep").setup({})
else
	require("dracula").setup({ italic_comment = true, transparent_bg = true })
	vim.cmd [[colorscheme dracula]]
	require("colorful-winsep").setup({
		hi = {
			bg = "#282A36",
			fg = "#50FA7B",
		},
	})
	-- TODO make the bar at the bottom green
end
vim.cmd [[ highlight Normal guibg=none ]]
vim.cmd [[ highlight Terminal guibg=none ]]

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

-- LANGUAGE SERVERS
require("lspconfig")["biome"].setup({})
require("lspconfig")["lua_ls"].setup({})
require("lspconfig")["omnisharp"].setup({ cmd = { "dotnet", "/usr/bin/omnisharp" } })

require("oil").setup({
	keymaps = {
		["q"] = { "actions.close", mode = "n" },
		["h"] = { "actions.parent", mode = "n" },
		["l"] = { "actions.select", mode = "n" },
		["e"] = { "actions.select", opts = { close = false, vertical = true }, mode = "n" },
		["E"] = { "actions.select", opts = { close = false, horizontal = true }, mode = "n" },
		["zh"] = { "actions.toggle_hidden", mode = "n" },
		["<Tab>"] = { "actions.preview", mode = "n" }, -- TODO shows an error on image preview
	},
	watch_for_changes = true,
})

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
	vim.keymap.set("n", "<leader>w", vim.cmd.terminal)
	vim.keymap.set("n", "<leader>q", vim.cmd.bd) -- buffer delete

	-- left hand home row
	vim.keymap.set("n", "<leader>g", function() Snacks.picker.grep() end)
	vim.keymap.set("n", "<leader>f", function() Snacks.picker.smart() end)
	vim.keymap.set("n", "<leader>d", function()
		Snacks.toggle.diagnostics():toggle()
		require("trouble").toggle({ mode = "diagnostics" })
	end)
	vim.keymap.set("n", "<leader>S", function() Snacks.picker.spelling() end)
	vim.keymap.set("n", "<leader>s", function() Snacks.picker.lsp_symbols() end)
	vim.keymap.set("n", "<leader>a", function() vim.cmd("GrugFar") end)

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
			vim.lsp.buf.format()
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
			vim.cmd([[ terminal timg %]])
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
}) do
	require("mini." .. plug).setup()
end

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
	terminal = { win = { position = "bottom", width = 200, height = 200 } },
	lazygit = { win = { position = "float" } },
	indent = {
		animate = { style = "down" },
		chunk = { enabled = true, char = { corner_top = "╭", corner_bottom = "╰" } },
		scope = { enabled = false },
	},
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

Setup_Keymap(); Setup_Autocmd()
