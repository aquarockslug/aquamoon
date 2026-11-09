local M = {}

local packages = {
	"https://github.com/nvim-mini/mini.nvim",
	"https://github.com/neovim/nvim-lspconfig",
	"https://github.com/nvim-treesitter/nvim-treesitter",
	"https://forge.barrettruth.com/barrettruth/canola.nvim",
	"https://github.com/leath-dub/snipe.nvim.git",
	"https://github.com/chrisgrieser/nvim-chainsaw.git",
	"https://github.com/alexpasmantier/tv.nvim",
	"https://github.com/zbirenbaum/copilot.lua.git",
	"https://github.com/folke/sidekick.nvim.git",
	-- colorschemes
	"https://github.com/NTBBloodbath/sweetie.nvim.git",
	"https://github.com/bluz71/vim-moonfly-colors.git",
	"https://github.com/mitander/flume.nvim.git",
	"https://github.com/rktjmp/lush.nvim.git", -- bluloco dependency
	"https://github.com/uloco/bluloco.nvim.git",
	"https://github.com/Badacadabra/vim-archery.git",
	"https://github.com/rktjmp/lush.nvim.git"
}

local mini_modules = {
	"ai", "basics", "bracketed", "comment", "diff", "icons", "jump", "move",
	"pairs", "surround", "trailspace", "visits", "jump2d", "completion",
}

function M.add()
	vim.pack.add(packages)
end

function M.setup()
	local map = vim.keymap.set

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

	for _, plugin in ipairs(mini_modules) do
		require("mini." .. plugin).setup()
	end
	require("neovim.starter").setup()
end

return M
