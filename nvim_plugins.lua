-- MINI.PLUGINS
require("mini.hipatterns").setup({
	highlighters = {
		WARN = { pattern = "%f[%w]()WARN()%f[%W]", group = "MiniHipatternsWarn" },
		HACK = { pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHipatternsHack" },
		TODO = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
	},
})

local starter = require('mini.starter')
require("mini.starter").setup({
	header = "",
	footer = "",
	evaluate_single = true,
	items = {
		starter.sections.recent_files(20, false),
	},
	content_hooks = {
		starter.gen_hook.aligning('center', 'top'),
		starter.gen_hook.padding(0, 5),
		starter.gen_hook.adding_bullet(vim.flag .. " "),
	},
})

for _, plug in ipairs({
	"ai",
	"align",
	"basics",
	"bracketed",
	"comment",
	"diff",
	"icons",
	"jump",
	"keymap",
	"move",
	"pairs",
	"sessions",
	"surround",
	"trailspace",
	"visits",
}) do
	require("mini." .. plug).setup()
end


-- OIL
function _G.get_oil_winbar()
	local bufnr = vim.api.nvim_win_get_buf(vim.g.statusline_winid)
	local dir = require("oil").get_current_dir(bufnr)
	if dir then
		return " " .. vim.flag .. " " .. vim.fn.fnamemodify(dir, ":~")
	else
		return " " .. vim.flag .. " " .. vim.api.nvim_buf_get_name(0)
	end
end

local mappings = require("nvim_mappings")
local oil_config = {
	watch_for_changes = true,
	use_default_keymaps = false,
	keymaps = mappings.oil_keymaps,
	columns = {
		"icon",
		"size"
	},
}

local settings = require "settings"
if settings.theme_name == "minicyan" or settings.theme_name == "moonfly" then
	oil_config.win_options = {
		winbar = "%!v:lua.get_oil_winbar()",
	}
end

require "oil".setup(oil_config)


-- CHAINSAW
require "chainsaw".setup()
require "cybu".setup()


-- COLORSCHEMES
vim.g.oceanic_next_terminal_bold = 1
vim.g.oceanic_next_terminal_italic = 1
require "neomodern".setup({ theme = "iceclimber", code_style = { comments = "italic" } })
require "bluloco".setup({ transparent = true, italics = true })


-- LEAP
require "leap".setup({})
require "leap".opts.preview = function(ch0, ch1, ch2)
	return not (
		ch1:match('%s')
		or (ch0:match('%a') and ch1:match('%a') and ch2:match('%a'))
	)
end
require "leap".opts.equivalence_classes = {
	' \t\r\n', '([{', ')]}', '\'"`'
}


-- TV
require "tv".setup({
	channels = {
		files = {
			keybinding = '<leader>f',
		},
		text = {
			keybinding = '<leader>g',
		},
	},
	window = {
		width = 1,
		height = 1,
	}
})


-- SNIPE
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


-- CLING
require("cling").setup({
	wrappers = {
		{
			binary = "lazygit",
			command = "Lg",
		},
		{
			binary = "lua " .. S.path .. "/scripts/theme_picker.lua",
			command = "Theme",
		},
		{
			binary = "lua ./deploy.lua",
			command = "Deploy",
		},
		{
			binary = "scooter",
			command = "Far",
		},
		{
			binary = "opencode",
			command = "Opencode",
		},
	}
})


-- LSP CONFIG
local lspconfig = require('lspconfig')
lspconfig.biome.setup({})
lspconfig.lua_ls.setup({})
lspconfig.gdscript.setup({})


-- DIAGNOSTICS
vim.diagnostic.config({
	signs = false,
	virtual_lines = true
})
vim.diagnostic.enable(false)
