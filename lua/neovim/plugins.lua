local M = {}

local packages = {
	"https://github.com/nvim-mini/mini.nvim",
	"https://github.com/neovim/nvim-lspconfig",
	"https://github.com/nvim-treesitter/nvim-treesitter",
	"https://forge.barrettruth.com/barrettruth/canola.nvim",
	"https://github.com/leath-dub/snipe.nvim.git",
	"https://github.com/chrisgrieser/nvim-chainsaw.git",
	"https://github.com/alexpasmantier/tv.nvim",
	"https://github.com/NeogitOrg/neogit.git",
	"https://github.com/brianhuster/unnest.nvim.git",
	"https://github.com/folke/sidekick.nvim.git",
	-- colorschemes
	"https://github.com/NTBBloodbath/sweetie.nvim.git",
	"https://github.com/bluz71/vim-moonfly-colors.git",
	"https://github.com/mitander/flume.nvim.git",
	"https://github.com/rktjmp/lush.nvim.git", -- bluloco dependency
	"https://github.com/uloco/bluloco.nvim.git",
	"https://github.com/Badacadabra/vim-archery.git",
}

local mini_modules = {
	"ai", "basics", "bracketed", "comment", "diff", "icons", "jump", "move",
	"pairs", "surround", "trailspace", "visits", "jump2d", "completion",
}

function M.add()
	vim.pack.add(packages)
end

function M.setup()
	local bindings = require("neovim.toml").load("neovim-bindings.toml")
	local tv_keys = bindings.tv or {}

	require("oil").setup({})
	require("snipe").setup()
	require("chainsaw").setup()
	require("neogit").setup({})
	local function ollama_claude(script, model, base_url)
		local base = {} ---@type table
		local path = vim.api.nvim_get_runtime_file("sk/cli/claude.lua", false)[1]
		if path then
			base = dofile(path)
		end
		return vim.tbl_deep_extend("force", base, {
			cmd = { vim.fn.expand(script) },
			env = {
				ANTHROPIC_BASE_URL = base_url,
				ANTHROPIC_AUTH_TOKEN = "ollama",
				ANTHROPIC_API_KEY = "",
				ANTHROPIC_DEFAULT_HAIKU_MODEL = model,
				ANTHROPIC_DEFAULT_SONNET_MODEL = model,
				ANTHROPIC_DEFAULT_OPUS_MODEL = model,
			},
		})
	end

	require("sidekick").setup({
		cli = {
			tools = {
				claude = ollama_claude("~/ai/WhiteRabbitNeo/run-claude.sh", "whiterabbitneo", "http://localhost:11434"),
				spawnpoint = ollama_claude(
					"~/ai/SpawnPoint-Coder-7B-GGUF/run-claude.sh",
					"spawnpoint",
					"http://127.0.0.1:11435"
				),
			},
		},
	})

	local has_ui2, ui2 = pcall(require, "vim._core.ui2")
	if has_ui2 and type(ui2.enable) == "function" then
		pcall(ui2.enable)
	end

	local tv = require("tv")
	local function tv_handlers(open)
		return {
			[tv_keys.open or "<CR>"] = open,
			[tv_keys.quickfix or "<C-q>"] = tv.handlers.send_to_quickfix,
			[tv_keys.split or "<C-s>"] = tv.handlers.open_in_split,
			[tv_keys.vsplit or "<C-v>"] = tv.handlers.open_in_vsplit,
			[tv_keys.yank or "<C-y>"] = tv.handlers.copy_to_clipboard,
		}
	end
	tv.setup({
		window = {
			width = 0.85,
			height = 0.85,
			border = "rounded",
			title = " television ",
			title_pos = "center",
		},
		global_keybindings = {
			channels = tv_keys.channels or "<leader>p",
		},
		channels = {
			files = {
				keybinding = tv_keys.files or "<leader>f",
				handlers = tv_handlers(tv.handlers.open_as_files),
			},
			text = {
				keybinding = tv_keys.text or "<leader>g",
				handlers = tv_handlers(tv.handlers.open_at_line),
			},
			aquamoon = {
				keybinding = tv_keys.aquamoon or "<leader>e",
				handlers = tv_handlers(tv.handlers.open_as_files),
			},
			palettes = {
				handlers = tv_handlers(tv.handlers.open_as_files),
			},
			["git-log"] = {
				keybinding = tv_keys.git_log or "<leader>gl",
				handlers = {
					[tv_keys.open or "<CR>"] = function(entries)
						if #entries > 0 then
							vim.cmd("enew | setlocal buftype=nofile bufhidden=wipe")
							vim.cmd("silent 0read !git show " ..
								vim.fn.shellescape(entries[1]))
							vim.cmd("1delete _ | setlocal filetype=git nomodifiable")
							vim.cmd("normal! gg")
						end
					end,
					[tv_keys.yank or "<C-y>"] = tv.handlers.copy_to_clipboard,
				},
			},
			["git-branch"] = {
				keybinding = tv_keys.git_branch or "<leader>gb",
				handlers = {
					[tv_keys.open or "<CR>"] = tv.handlers.execute_shell_command("git checkout {}"),
					[tv_keys.yank or "<C-y>"] = tv.handlers.copy_to_clipboard,
				},
			},
			["git-diff"] = {
				keybinding = tv_keys.git_diff or "<leader>gd",
				handlers = tv_handlers(tv.handlers.open_as_files),
			},
		},
	})

	for _, plugin in ipairs(mini_modules) do
		require("mini." .. plugin).setup()
	end
	require("neovim.starter").setup()
end

return M
