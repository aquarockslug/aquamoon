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
vim.keymap.set("n", "<C-down>", vim.cmd.quit)
vim.keymap.set("n", "<C-left>", vim.cmd.tabprevious)
vim.keymap.set("n", "<C-right>", vim.cmd.tabnext)

-- FUNCTION KEYS
local Terminal = require("toggleterm.terminal").Terminal
local floater = function(cmd)
	return Terminal:new({ cmd = cmd, direction = "float" })
end
local open_glow = function()
	return floater("glow --pager " .. vim.fn.expand("%:p")):toggle()
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
	[3] = function() -- file browser
		floater("lf"):toggle()
	end,
	-- TODO: only use glow on markdown files, replace with ddgr
	[4] = function() -- view current file with glow
		-- quick open note if not a markdown buffer
		open_glow()
	end,
	[5] = function() -- menu: web search, web bookmarks, browse notes
		floater('$(gum choose "nap" "ddgr" "oil" "tldr")'):toggle()
	end,
}) do
	vim.keymap.set("n", "<F" .. cmd .. ">", func)
end

-- TODO: add selection to nap notes

-- LEADER SHORTCUTS
for cmd, func in pairs({
	h = vim.cmd.noh, -- clear highlighting
	j = ":move+<CR>==", -- shift line up
	k = ":move-2<CR>==", -- shift line down
	t = function() -- blank terminal
		alrighty("zsh"):toggle()
	end,
	v = vim.cmd.Vexplore, -- open netrw in vertical pane
	V = vim.cmd.Hexplore, -- open netrw in horizontal pane
	r = vim.cmd.WinResizerStartResize,
	m = vim.cmd.WinResizerStartMove,
}) do
	vim.keymap.set("n", "<leader>" .. cmd, func)
end

-- TELESCOPE SHORTCUTS
local telescope_prefix = "<leader>f"
local t = require("telescope")
local tb = require("telescope.builtin")
for cmd, func in pairs({
	b = t.extensions.file_browser.file_browser,
	d = vim.cmd.DevdocsOpenCurrentFloat3,
	f = tb.find_files,
	g = tb.live_grep,
	h = tb.jumplist,
	-- j = ":TodoTelescope<CR>",
	m = tb.man_pages,
	o = tb.oldfiles,
	s = tb.spell_suggest,
	t = tb.treesitter,
	w = tb.current_buffer_fuzzy_find,
}) do
	vim.keymap.set("n", telescope_prefix .. cmd, func)
end

-- TODO: add lsp telescope and leader shortcuts
