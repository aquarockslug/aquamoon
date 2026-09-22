-- data at ~/.local/share/mini

vim.pack.add({
	'https://github.com/nvim-mini/mini.nvim',
	'https://github.com/neovim/nvim-lspconfig',
	'https://github.com/nvim-treesitter/nvim-treesitter',
	'https://forge.barrettruth.com/barrettruth/canola.nvim',
	'https://github.com/leath-dub/snipe.nvim.git',
	'https://github.com/chrisgrieser/nvim-chainsaw.git',
	-- colorschemes
	'https://github.com/NTBBloodbath/sweetie.nvim.git',
	'https://github.com/bluz71/vim-moonfly-colors.git',
	'https://github.com/mitander/flume.nvim.git',
	'https://github.com/uloco/bluloco.nvim.git',
})

require "oil".setup({})

local snipe = require("snipe")
snipe.setup()
vim.keymap.set("n", "<Space>", snipe.open_buffer_menu)

require("chainsaw").setup()
require('vim._core.ui2').enable()

-- Settings from settings.toml (same file open_dir.lua reads). open_dir.lua uses
-- the toml_edit rock, a Lua 5.5 C module nvim's LuaJIT cannot load, so we parse
-- it here with the built-in lua/settings.lua parser.
local settings_fh = io.open(vim.fn.stdpath("config") .. "/settings.toml", "rb")
local settings = {}
if settings_fh then
	local ok, res = pcall(function()
		local src = settings_fh:read("*a")
		settings_fh:close()
		return require("settings").parse(src)
	end)
	if ok then
		settings = res
	else
		vim.notify("settings.toml: " .. tostring(res), vim.log.levels.WARN)
	end
end

for opt, value in pairs(settings.options or {}) do
	if opt == "leader" then
		vim.g.mapleader = value
	else
		local ok, err = pcall(function() vim.o[opt] = value end)
		if not ok then
			vim.notify(
				string.format("settings.toml: could not apply option '%s': %s", opt, err),
				vim.log.levels.WARN
			)
		end
	end
end

vim.cmd("colorscheme sweetie")
if vim.g.neovide then
	vim.g.neovide_opacity = 0.9
	vim.o.guifont = "Fairiesevka Nerd Font:h14"
end

-- KEYBINDS
vim.keymap.set("n", "<leader>/", ":noh<CR>")
vim.keymap.set("n", "<leader>l", ":Chainsaw variableLog<CR>")

-- Open oil in a split
vim.keymap.set("n", "<leader>l", function()
	vim.cmd.split()
	vim.cmd.Oil()
end)
vim.keymap.set("n", "<leader>;", function()
	vim.cmd.vsplit()
	vim.cmd.Oil()
end)

-- Arrow keys switch windows
vim.keymap.set("n", "<Left>", "<C-w>h")
vim.keymap.set("n", "<Down>", "<C-w>j")
vim.keymap.set("n", "<Up>", "<C-w>k")
vim.keymap.set("n", "<Right>", "<C-w>l")

-- Redo on U (instead of the default "undo line" command)
vim.keymap.set("n", "U", "<C-r>")

-- MINI PLUGINS
local mini_setup = {
	"ai", "basics", "bracketed", "comment", "diff", "icons", "jump", "move",
	"pairs", "surround", "trailspace", "visits", "jump2d", "completion"
}
for _, plug in pairs(mini_setup) do
	require("mini." .. plug).setup()
end

require("mini.starter").setup()

-- TREESITTER -----------------------------------------------------------------
local ok_ts, treesitter = pcall(require, "nvim-treesitter")
if ok_ts then
	treesitter.setup()

	local ts_langs = {
		"lua", "vim", "vimdoc",
		"javascript", "jsdoc", "typescript", "tsx",
		"html", "css", "json",
	}
	local installed = treesitter.get_installed("parsers")
	local missing = vim.tbl_filter(function(lang)
		return not vim.list_contains(installed, lang)
	end, ts_langs)
	if #missing > 0 then
		vim.schedule(function()
			vim.notify(
				"Installing treesitter parsers: " .. table.concat(missing, ", "),
				vim.log.levels.INFO
			)
			treesitter.install(missing)
		end)
	end
end

-- LSP ------------------------------------------------------------------------
-- Lua (lua-language-server)
vim.lsp.config("lua_ls", {
	on_init = function(client)
		local path = client.workspace_folders and client.workspace_folders[1].name
		if path and path ~= vim.fn.stdpath("config")
		    and (vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc"))
		then
			return
		end

		client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
			runtime = {
				version = "LuaJIT",
				path = { "lua/?.lua", "lua/?/init.lua", vim.fn.stdpath("config") .. "/lua_modules/share/lua/5.1/?.lua" },
			},
			workspace = {
				library = {
					vim.env.VIMRUNTIME,
					vim.fn.stdpath("config"),
				},
			},
			telemetry = { enable = false },
		})
	end,
})

-- JavaScript / TypeScript / JSON (biome)
if vim.fn.executable("biome") == 0 then
	vim.notify(
		"biome not found on PATH. Install it with:\n"
		.. "curl -LsSf https://biomejs.dev/install.sh | sh",
		vim.log.levels.WARN
	)
else
	vim.lsp.config("biome", {
		-- Attach to JS/TS files even without a biome.json, unlike the
		-- nvim-lspconfig default which requires a biome config in the project.
		filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "json", "jsonc" },
		workspace_required = false,
		root_dir = function(bufnr, on_dir)
			on_dir(vim.fs.root(bufnr, { ".git", "package.json", "biome.json", "biome.jsonc" }) or
				vim.fn.getcwd())
		end,
	})
end

local lsp_enabled = { "lua_ls" }
if vim.fn.executable("biome") == 1 then
	table.insert(lsp_enabled, "biome")
end
vim.lsp.enable(lsp_enabled)

-- LSP keymaps
vim.keymap.set("n", "gd", vim.lsp.buf.definition)
vim.keymap.set("n", "gr", vim.lsp.buf.references)
vim.keymap.set("n", "K", vim.lsp.buf.hover)
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename)
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action)
vim.keymap.set("n", "[d", function() vim.diagnostic.jump({ count = -1 }) end)
vim.keymap.set("n", "]d", function() vim.diagnostic.jump({ count = 1 }) end)
vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float)

-- Save and format
vim.keymap.set("n", "<leader>j", function()
	pcall(vim.lsp.buf.format, { async = false })
	vim.cmd("write")
end)

-- Start treesitter highlighting in buffers that have a parser available.
-- On nvim 0.13 (and earlier), vim.treesitter.start() errors for buffers
-- without a parser (empty buffers, oil dirs, mini.starter, ...).
-- Those are common at startup when launching from neovide, so guard it.
local function ts_start(buf, lang)
	if lang then
		pcall(vim.treesitter.start, buf, lang)
	end
end

-- Start highlighting whenever a javascript or lua file is opened.
-- NOTE: on this nvim 0.13 nightly `ev.filetype` is nil; use vim.bo[ev.buf] instead.
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "javascript", "lua" },
	callback = function(ev)
		ts_start(ev.buf, vim.treesitter.language.get_lang(vim.bo[ev.buf].filetype))
	end,
})

-- The startup buffer's FileType event already fired before init.lua ran.
ts_start(0, vim.treesitter.language.get_lang(vim.bo.filetype))

-- If a file was opened while parsers were still installing (async install
-- scheduled above), retry once nvim-treesitter reports completion.
vim.api.nvim_create_autocmd("User", {
	pattern = "TSUpdate",
	callback = function()
		local buf = vim.api.nvim_get_current_buf()
		local lang = vim.treesitter.language.get_lang(vim.bo.filetype)
		if lang and not vim.treesitter.highlighter.active[buf] then
			ts_start(buf, lang)
		end
	end,
})
