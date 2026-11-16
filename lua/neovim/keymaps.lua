local M = {}

local actions = {
	["oil:split"] = function()
		vim.cmd.split(); vim.cmd.Oil()
	end,
	["oil:vsplit"] = function()
		vim.cmd.vsplit(); vim.cmd.Oil()
	end,
	["terminal:split"] = function()
		vim.cmd.split(); vim.cmd.terminal()
	end,
	["terminal:vsplit"] = function()
		vim.cmd.vsplit(); vim.cmd.terminal()
	end,
	["snipe:menu"] = function() require("snipe").open_buffer_menu() end,
	["chainsaw:variable"] = function() require("chainsaw").variableLog() end,
	["chainsaw:object"] = function() require("chainsaw").objectLog() end,
	["chainsaw:message"] = function() require("chainsaw").messageLog() end,
	["chainsaw:remove"] = function() require("chainsaw").removeLogs() end,
	["neogit:open"] = function() require("neogit").open() end,
	["neogit:commit"] = function() require("neogit").open({ "commit" }) end,
	["sidekick:toggle"] = function() require("sidekick.cli").toggle({ name = "claude", focus = true }) end,
	["sidekick:toggle_spawnpoint"] = function() require("sidekick.cli").toggle({ name = "spawnpoint", focus = true }) end,
	["sidekick:select"] = function() require("sidekick.cli").select() end,
	["sidekick:prompt"] = function() require("sidekick.cli").prompt() end,
	["mini:trim_whitespace"] = function() MiniTrailspace.trim() end,
	["mini:diff_overlay"] = function() MiniDiff.toggle_overlay() end,
	["mini:starter"] = function() MiniStarter.open() end,
	["lsp:definition"] = vim.lsp.buf.definition,
	["lsp:references"] = vim.lsp.buf.references,
	["lsp:hover"] = vim.lsp.buf.hover,
	["lsp:rename"] = vim.lsp.buf.rename,
	["lsp:code_action"] = vim.lsp.buf.code_action,
	["lsp:diagnostic_prev"] = function() vim.diagnostic.jump({ count = -1 }) end,
	["lsp:diagnostic_next"] = function() vim.diagnostic.jump({ count = 1 }) end,
	["lsp:diagnostic_float"] = vim.diagnostic.open_float,
	["lsp:format_save"] = function()
		pcall(vim.lsp.buf.format, { async = false })
		vim.cmd("write")
	end,
}

function M.setup()
	local config = require("neovim.toml").load("neovim-bindings.toml")
	for _, b in ipairs(((config.map or {}).bindings) or {}) do
		if b.key and b.action then
			local mode = b.mode or "n"
			if type(mode) == "string" and #mode > 1 then
				local modes = {}
				for i = 1, #mode do
					modes[i] = mode:sub(i, i)
				end
				mode = modes
			end
			vim.keymap.set(mode, b.key, actions[b.action] or b.action, b.desc and { desc = b.desc } or nil)
		end
	end
end

return M
