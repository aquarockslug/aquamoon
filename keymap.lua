-- AQUA ARCH NEOVIM KEYMAP
local vim = vim -- avoid undefined var warning
local notify = MiniNotify

vim.keymap.set("n", "U", "<C-r>") -- undo

-- MOVEMENT SHORTCUTS
vim.keymap.set("n", "<up>", "<C-w><up>")
vim.keymap.set("n", "<down>", "<C-w><down>")
vim.keymap.set("n", "<left>", "<C-w><left>")
vim.keymap.set("n", "<right>", "<C-w><right>")

vim.keymap.set("n", "<C-up>", vim.cmd.tabs)
vim.keymap.set("n", "<C-down>", require("mini.bufremove").delete)
vim.keymap.set("n", "<C-left>", vim.cmd.tabprevious)
vim.keymap.set("n", "<C-right>", vim.cmd.tabnext)

-- FUNCTION KEYS
local Terminal = require("toggleterm.terminal").Terminal
local floater = function(cmd)
	return Terminal:new({ cmd = cmd, direction = "float" })
end
for cmd, func in pairs({
	[1] = function() -- git
		floater("lazygit"):toggle()
	end,
	[2] = function() -- format and save
		notify.add("Formatting...")
		require("conform").format()
		vim.cmd.write()
		notify.clear()
	end,
	[3] = function() -- web search
		floater("ddgr --rev"):toggle()
	end,
	[4] = function() -- view with glow
		floater("glow --pager " .. vim.fn.expand("%:p")):toggle()
	end,
	[5] = function() -- notes
		floater("nap"):toggle()
	end,
	[6] = function() -- quick view a note
		floater("nap $(nap list | peco) | gum pager"):toggle()
	end,
	[7] = function() -- web bookmarks
		floater("oil"):toggle()
	end,
}) do
	vim.keymap.set("n", "<F" .. cmd .. ">", func)
end

-- LEADER SHORTCUTS
for cmd, func in pairs({
	h = vim.cmd.noh, -- clear highlighting
	j = ":move+<CR>==", -- shift line up
	k = ":move-2<CR>==", -- shift line down
	o = vim.cmd.Hexplore, -- open netrw in horizontal pane
	t = vim.cmd.Texplore, -- open netrw in new tab
	v = vim.cmd.Vexplore, -- open netrw in vertical pane
}) do
	vim.keymap.set("n", "<leader>" .. cmd, func)
end

-- TELESCOPE SHORTCUTS
local telescope_prefix = "<leader>f"
local t = require("telescope")
local tb = require("telescope.builtin")
local dropdown = function(telescope_func)
	telescope_func(require("telescope.themes").get_dropdown({ winblend = 10 }))
end
for cmd, func in pairs({
	b = function()
		dropdown(t.extensions.file_browser.file_browser)
	end,
	d = vim.cmd.DevdocsOpenCurrentFloat3,
	f = function()
		dropdown(tb.find_files)
	end,
	g = tb.live_grep,
	h = tb.jumplist,
	-- j = ":TodoTelescope<CR>",
	m = tb.man_pages,
	o = function()
		dropdown(tb.oldfiles)
	end,
	s = tb.spell_suggest,
	t = tb.treesitter,
	w = tb.current_buffer_fuzzy_find,
}) do
	vim.keymap.set("n", telescope_prefix .. cmd, func)
end

-- TODO: add lsp telescope and leader shortcuts
