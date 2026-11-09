local M = {}

local parsers = {
	"lua", "vim", "vimdoc",
	"javascript", "jsdoc", "typescript", "tsx",
	"html", "css", "json",
}

local function ts_start(buffer)
	local lang = vim.treesitter.language.get_lang(vim.bo[buffer].filetype)
	if lang then
		pcall(vim.treesitter.start, buffer, lang)
	end
end

function M.setup()
	local has_treesitter, treesitter = pcall(require, "nvim-treesitter")
	if has_treesitter then
		treesitter.setup()
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
end

return M
