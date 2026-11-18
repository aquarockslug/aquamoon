local M = {}

-- Named actions referenced by lua/neovim/keymaps.lua. Bindings whose
-- action is not listed here are used verbatim as the mapping's rhs.
local actions = {
	["terminal:split"] = function()
		vim.cmd.split(); vim.cmd.terminal()
	end,
	["terminal:vsplit"] = function()
		vim.cmd.vsplit(); vim.cmd.terminal()
	end,
	["oil:split"] = function()
		vim.cmd.split(); require("oil").open()
	end,
	["oil:vsplit"] = function()
		vim.cmd.vsplit(); require("oil").open()
	end,
	["snipe:menu"] = function() require("snipe").open_buffer_menu() end,
	["chainsaw:variable"] = function() require("chainsaw").variableLog() end,
	["chainsaw:object"] = function() require("chainsaw").objectLog() end,
	["chainsaw:message"] = function() require("chainsaw").messageLog() end,
	["chainsaw:remove"] = function() require("chainsaw").removeLogs() end,
	["neogit:open"] = function()
		local cwd = vim.fn.expand("%:p:h")
		if cwd == "" then cwd = vim.uv.cwd() end
		require("neogit").open({ cwd = cwd })
	end,
	["neogit:commit"] = function()
		local cwd = vim.fn.expand("%:p:h")
		if cwd == "" then cwd = vim.uv.cwd() end
		require("neogit").open({ "commit", cwd = cwd })
	end,
	["sidekick:toggle"] = function() require("sidekick.cli").toggle({ name = "claude", focus = true }) end,
	["sidekick:toggle_spawnpoint"] = function() require("sidekick.cli").toggle({ name = "spawnpoint", focus = true }) end,
	["sidekick:prompt"] = function() require("sidekick.cli").prompt() end,
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
	for mode, bindings in pairs(config.map or {}) do
		local modes = {}
		for i = 1, #mode do
			modes[i] = mode:sub(i, i)
		end
		for _, binding in ipairs(bindings) do
			local key, action, desc = binding[1], binding[2], binding[3]
			if key and action then
				vim.keymap.set(modes, key, actions[action] or action, desc and { desc = desc } or nil)
			end
		end
	end
end

return M
