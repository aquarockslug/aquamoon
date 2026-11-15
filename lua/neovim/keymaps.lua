local M = {}

local actions = {
	["oil:split"] = function()
		vim.cmd.split()
		vim.cmd.Oil()
	end,
	["oil:vsplit"] = function()
		vim.cmd.vsplit()
		vim.cmd.Oil()
	end,
	["terminal:split"] = function()
		vim.cmd.split()
		vim.cmd.terminal()
	end,
	["terminal:vsplit"] = function()
		vim.cmd.vsplit()
		vim.cmd.terminal()
	end,
	["snipe:menu"] = function()
		require("snipe").open_buffer_menu()
	end,
	["chainsaw:variable"] = function()
		require("chainsaw").variableLog()
	end,
	["chainsaw:object"] = function()
		require("chainsaw").objectLog()
	end,
	["chainsaw:message"] = function()
		require("chainsaw").messageLog()
	end,
	["chainsaw:remove"] = function()
		require("chainsaw").removeLogs()
	end,
	["neogit:open"] = function()
		require("neogit").open()
	end,
	["neogit:commit"] = function()
		require("neogit").open({ "commit" })
	end,
	["sidekick:toggle"] = function()
		require("sidekick.cli").toggle()
	end,
	["sidekick:select"] = function()
		require("sidekick.cli").select()
	end,
	["sidekick:prompt"] = function()
		require("sidekick.cli").prompt()
	end,
	["mini:trim_whitespace"] = function()
		MiniTrailspace.trim()
	end,
	["mini:diff_overlay"] = function()
		MiniDiff.toggle_overlay()
	end,
	["mini:starter"] = function()
		MiniStarter.open()
	end,
	["lsp:definition"] = function()
		vim.lsp.buf.definition()
	end,
	["lsp:references"] = function()
		vim.lsp.buf.references()
	end,
	["lsp:hover"] = function()
		vim.lsp.buf.hover()
	end,
	["lsp:rename"] = function()
		vim.lsp.buf.rename()
	end,
	["lsp:code_action"] = function()
		vim.lsp.buf.code_action()
	end,
	["lsp:diagnostic_prev"] = function()
		vim.diagnostic.jump({ count = -1 })
	end,
	["lsp:diagnostic_next"] = function()
		vim.diagnostic.jump({ count = 1 })
	end,
	["lsp:diagnostic_float"] = function()
		vim.diagnostic.open_float()
	end,
	["lsp:format_save"] = function()
		pcall(vim.lsp.buf.format, { async = false })
		vim.cmd("write")
	end,
}

function M.setup()
	local config = require("neovim.toml").load("neovim-bindings.toml")
	local bindings = ((config.map or {}).bindings) or {}
	local map = vim.keymap.set

	for _, b in ipairs(bindings) do
		if b.key and b.action then
			local mode = b.mode or "n"
			if type(mode) == "string" and #mode > 1 then
				local modes = {}
				for i = 1, #mode do
					modes[i] = mode:sub(i, i)
				end
				mode = modes
			end
			local rhs = actions[b.action] or b.action
			local opts = b.desc and { desc = b.desc } or nil
			map(mode, b.key, rhs, opts)
		end
	end
end

return M
