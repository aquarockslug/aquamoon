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
	"https://github.com/folke/which-key.nvim.git",
	"https://github.com/folke/sidekick.nvim.git",
	"https://github.com/brianhuster/live-preview.nvim",
	-- colorschemes
	"https://github.com/NTBBloodbath/sweetie.nvim.git",
	"https://github.com/bluz71/vim-moonfly-colors.git",
	"https://github.com/mitander/flume.nvim.git",
	"https://github.com/rktjmp/lush.nvim.git", -- bluloco dependency
	"https://github.com/uloco/bluloco.nvim.git",
	"https://github.com/Badacadabra/vim-archery.git",
	"https://github.com/FrenzyExists/aquarium-vim.git",
	"https://github.com/zootedb0t/citruszest.nvim.git",
	"https://github.com/tanmaymanojgandhi/circadia.git",
	"https://github.com/nvimdev/zephyr-nvim.git",
}

local mini_modules = {
	"ai", "basics", "bracketed", "comment", "diff", "icons", "jump", "move",
	"pairs", "surround", "trailspace", "visits", "jump2d", "completion", "bufremove"
}

function M.add()
	vim.pack.add(packages)
	-- circadia keeps its neovim files under ports/neovim/, not at the repo root
	local circadia_rtp = vim.fn.stdpath("data") .. "/site/pack/core/opt/circadia/ports/neovim"
	if vim.fn.isdirectory(circadia_rtp) == 1 then
		vim.opt.runtimepath:append(circadia_rtp)
	end
end

function M.setup()
	local bindings = require("neovim.toml").load("neovim-bindings.toml")
	local tv_keys = bindings.tv or {}

	require("neovim.oil").setup()
	require("oil").setup({
		columns = { "icon", "total_size" },
		keymaps = {
			["<Tab>"] = "actions.preview",
		},
	})
	require("snipe").setup()
	require("chainsaw").setup()
	require("neogit").setup({})

	vim.o.background = "dark"

	local wk_spec = {}
	for prefix, group in pairs(bindings.groups or {}) do
		wk_spec[#wk_spec + 1] = { prefix, group = group }
	end
	require("which-key").setup({
		win = { border = "rounded" },
		spec = wk_spec,
	})
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
				claude = ollama_claude("~/ai/WhiteRabbitNeo/run-claude.sh", "whiterabbitneo",
					"http://localhost:11434"),
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
				keybinding = tv_keys.text or "<leader>s",
				handlers = tv_handlers(tv.handlers.open_at_line),
			},
			aquamoon = {
				handlers = tv_handlers(tv.handlers.open_as_files),
			},
			palettes = {
				handlers = tv_handlers(tv.handlers.open_as_files),
			},
			["git-log"] = {
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
				handlers = {
					[tv_keys.open or "<CR>"] = tv.handlers.execute_shell_command("git checkout {}"),
					[tv_keys.yank or "<C-y>"] = tv.handlers.copy_to_clipboard,
				},
			},
			["git-diff"] = {
				handlers = tv_handlers(tv.handlers.open_as_files),
			},
		},
	})

	-- Override tv keybindings to launch from the current buffer's directory,
	-- restoring the original working directory when the tv terminal closes.
	do
		local function tv_from_bufdir(fn, ...)
			local args = { ... }
			local buf_dir = vim.fn.expand("%:p:h")
			if buf_dir == "" or vim.fn.isdirectory(buf_dir) ~= 1 then
				return fn(unpack(args))
			end
			local saved = vim.fn.getcwd()
			vim.cmd("cd " .. vim.fn.fnameescape(buf_dir))
			fn(unpack(args))
			local bufnr = vim.api.nvim_get_current_buf()
			if vim.bo[bufnr].buftype == "terminal" then
				vim.api.nvim_create_autocmd("TermClose", {
					buffer = bufnr,
					once = true,
					callback = function()
						vim.cmd("cd " .. vim.fn.fnameescape(saved))
					end,
				})
			end
		end

		for channel_name, channel_config in pairs(tv.config.channels) do
			if channel_config.keybinding then
				vim.keymap.set("n", channel_config.keybinding, function()
					tv_from_bufdir(tv.tv_channel, channel_name)
				end, { desc = "TV: " .. channel_name .. " (buffer dir)" })
			end
		end

		if tv.config.global_keybindings.channels then
			vim.keymap.set("n", tv.config.global_keybindings.channels, function()
				tv_from_bufdir(tv.tv_channels)
			end, { desc = "TV: Channels (buffer dir)" })
		end
	end

	for _, plugin in ipairs(mini_modules) do
		require("mini." .. plugin).setup()
	end
	require("neovim.starter").setup()

	vim.api.nvim_create_autocmd("FileType", {
		group = vim.api.nvim_create_augroup("MarkdownLivePreview", { clear = true }),
		pattern = { "markdown", "mdx" },
		callback = function()
			vim.cmd("LivePreview")
		end,
	})
end

return M
