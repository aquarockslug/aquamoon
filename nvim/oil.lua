-- OIL
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

-- send all the files in the current directory to the quickfix list
local function oil_files_to_quickfix()
	if vim.bo.filetype ~= 'oil' then return end
	local oil = require 'oil'
	local dir = oil.get_current_dir()

	local entries = {}
	for i = 1, vim.fn.line '$' do
		local entry = oil.get_entry_on_line(0, i)
		if entry and entry.type == 'file' then
			table.insert(entries, { filename = dir .. entry.name })
		end
	end
	if #entries == 0 then return end

	vim.fn.setqflist(entries)
	return vim.cmd.copen()
end

local oil_config = {
	watch_for_changes = true,
	use_default_keymaps = false,
	keymaps = {
		["H"] = { "actions.parent", mode = "n" },
		["L"] = { "actions.select", mode = "n" },
		["e"] = { "actions.select", opts = { close = false, vertical = true }, mode = "n" },
		["E"] = { "actions.select", opts = { close = false, horizontal = true }, mode = "n" },
		["<Tab>"] = { "actions.preview", mode = "n" }, -- TODO shows an error on image preview
		['<C-q>'] = oil_files_to_quickfix,

		["zo"] = { "actions.open_external", mode = "n" },
		["zy"] = { "actions.yank_entry", mode = "n" },
		["zz"] = { "actions.open_terminal", mode = "n" },
		["zh"] = { "actions.toggle_hidden", mode = "n" },
	},
	columns = {
		"icon",
		"size"
	},
}

-- only add win_options if using a colorscheme that supports winbar
local settings = require "settings"
if settings.theme_name == "minicyan" or settings.theme_name == "moonfly" then
	oil_config.win_options = {
		winbar = "%!v:lua.get_oil_winbar()",
	}
end

require "oil".setup(oil_config)
