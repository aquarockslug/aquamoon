vim.g.mapleader = ","

vim.pack.add({
	"https://github.com/nvim-mini/mini.nvim",
	"https://github.com/neovim/nvim-lspconfig",
	"https://github.com/nvim-treesitter/nvim-treesitter",
	"https://forge.barrettruth.com/barrettruth/canola.nvim",
	"https://github.com/leath-dub/snipe.nvim.git",
	"https://github.com/chrisgrieser/nvim-chainsaw.git",
	"https://github.com/alexpasmantier/tv.nvim",
	"https://github.com/NTBBloodbath/sweetie.nvim.git",
	"https://github.com/bluz71/vim-moonfly-colors.git",
	"https://github.com/mitander/flume.nvim.git",
	"https://github.com/uloco/bluloco.nvim.git",
	"https://github.com/Badacadabra/vim-archery.git",
})

local function load(file)
	local ok, result = pcall(require("tinytoml").parse, vim.fn.stdpath("config") .. "/toml/" .. file)
	if not ok then
		vim.notify(file .. ": " .. tostring(result), vim.log.levels.WARN)
	end
	return ok and result or {}
end

local noctalia = load("noctalia.toml")

local function apply_theme()
	local ok, palette = pcall(dofile, vim.fn.stdpath("cache") .. "/noctalia.lua")
	if ok and type(palette) == "table" then
		local r, g, b = (palette.base00 or ""):match("^#(%x%x)(%x%x)(%x%x)")
		if r then
			local luminance = 0.2126 * tonumber(r, 16) + 0.7152 * tonumber(g, 16) + 0.0722 * tonumber(b, 16)
			vim.o.background = luminance > 127 and "light" or "dark"
		end
		if pcall(function()
			require("mini.base16").setup({ palette = palette })
		end) then
			return
		end
	end
	vim.cmd.colorscheme("sweetie")
end

apply_theme()
_G.noctalia_theme_signal = vim.uv.new_signal()
_G.noctalia_theme_signal:start("sigusr1", vim.schedule_wrap(apply_theme))

if vim.g.neovide then
	vim.g.neovide_opacity = 0.9
	local font = (noctalia.shell or {}).font_family or "FairiesevkaTerm Nerd Font Mono"
	vim.o.guifont = font .. ":h16"
end

vim.o.clipboard = "unnamedplus"

local map = vim.keymap.set
map("n", "<leader>/", ":noh<CR>")
map("n", "<leader>l", function()
	vim.cmd.split()
	vim.cmd.Oil()
end)
map("n", "<leader>;", function()
	vim.cmd.vsplit()
	vim.cmd.Oil()
end)
for key, command in pairs({ Left = "<C-w>h", Down = "<C-w>j", Up = "<C-w>k", Right = "<C-w>l" }) do
	map("n", "<" .. key .. ">", command)
end
map("n", "U", "<C-r>")

require("oil").setup({})
local snipe = require("snipe")
snipe.setup()
map("n", "<Space>", snipe.open_buffer_menu)
require("chainsaw").setup()
require("vim._core.ui2").enable()

local tv = require("tv")
local function tv_handlers(open)
	return {
		["<CR>"] = open,
		["<C-q>"] = tv.handlers.send_to_quickfix,
		["<C-s>"] = tv.handlers.open_in_split,
		["<C-v>"] = tv.handlers.open_in_vsplit,
	}
end
tv.setup({
	channels = {
		files = { keybinding = "<leader>f", handlers = tv_handlers(tv.handlers.open_as_files) },
		text = { keybinding = "<leader>g", handlers = tv_handlers(tv.handlers.open_at_line) },
	},
})

for _, plugin in ipairs({
	"ai", "basics", "bracketed", "comment", "diff", "icons", "jump", "move",
	"pairs", "surround", "trailspace", "visits", "jump2d", "completion", "starter",
}) do
	require("mini." .. plugin).setup()
end

local has_treesitter, treesitter = pcall(require, "nvim-treesitter")
if has_treesitter then
	treesitter.setup()
	local parsers = {
		"lua", "vim", "vimdoc",
		"javascript", "jsdoc", "typescript", "tsx",
		"html", "css", "json",
	}
	local installed = treesitter.get_installed("parsers")
	local missing = vim.tbl_filter(function(lang)
		return not vim.list_contains(installed, lang)
	end, parsers)
	if #missing > 0 then
		vim.schedule(function()
			vim.notify("Installing treesitter parsers: " .. table.concat(missing, ", "), vim.log.levels.INFO)
			treesitter.install(missing)
		end)
	end
end

vim.lsp.config("lua_ls", {
	on_init = function(client)
		local root = client.workspace_folders and client.workspace_folders[1].name
		if root and root ~= vim.fn.stdpath("config")
			and (vim.uv.fs_stat(root .. "/.luarc.json") or vim.uv.fs_stat(root .. "/.luarc.jsonc")) then
			return
		end
		client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
			runtime = { version = "LuaJIT", path = { "?.lua", "lua/?.lua", "lua/?/init.lua" } },
			workspace = { library = { vim.env.VIMRUNTIME, vim.fn.stdpath("config") } },
			telemetry = { enable = false },
		})
	end,
})

local has_biome = vim.fn.executable("biome") == 1
if has_biome then
	vim.lsp.config("biome", {
		filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "json", "jsonc" },
		workspace_required = false,
		root_dir = function(buffer, on_dir)
			on_dir(vim.fs.root(buffer, { ".git", "package.json", "biome.json", "biome.jsonc" }) or vim.fn.getcwd())
		end,
	})
else
	vim.notify(
		"biome not found on PATH. Install it with:\ncurl -LsSf https://biomejs.dev/install.sh | sh",
		vim.log.levels.WARN
	)
end
vim.lsp.enable(has_biome and { "lua_ls", "biome" } or { "lua_ls" })

map("n", "gd", vim.lsp.buf.definition)
map("n", "gr", vim.lsp.buf.references)
map("n", "K", vim.lsp.buf.hover)
map("n", "<leader>rn", vim.lsp.buf.rename)
map("n", "<leader>ca", vim.lsp.buf.code_action)
map("n", "[d", function() vim.diagnostic.jump({ count = -1 }) end)
map("n", "]d", function() vim.diagnostic.jump({ count = 1 }) end)
map("n", "<leader>d", vim.diagnostic.open_float)
map("n", "<leader>j", function()
	pcall(vim.lsp.buf.format, { async = false })
	vim.cmd("write")
end)

local function ts_start(buffer)
	local lang = vim.treesitter.language.get_lang(vim.bo[buffer].filetype)
	if lang then
		pcall(vim.treesitter.start, buffer, lang)
	end
end

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "javascript", "lua" },
	callback = function(event)
		ts_start(event.buf)
	end,
})
ts_start(0)
vim.api.nvim_create_autocmd("User", {
	pattern = "TSUpdate",
	callback = function()
		local buffer = vim.api.nvim_get_current_buf()
		if not vim.treesitter.highlighter.active[buffer] then
			ts_start(buffer)
		end
	end,
})
