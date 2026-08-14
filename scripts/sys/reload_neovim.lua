-- Reloads the aquamoon theme in every running Neovim/Neovide instance

local M = {}

function M.reload()
	local patterns = {
		"/run/user/*/nvim.*.0",
		"/tmp/neovide-*.sock",
	}
	local cmd = "for sock in " .. table.concat(patterns, " ") .. "; do "
		.. 'nvim --server "$sock" --remote-send "<C-o>:AquaReloadTheme<CR>" 2>/dev/null || true; '
		.. "done"
	os.execute(cmd)
end

return M
