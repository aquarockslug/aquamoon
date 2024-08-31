vim.opt.clipboard = "unnamedplus" -- allows neovim to access the system clipboard

-- Set wsl-clipboard if running WSL
local function is_wsl()
	local version_file = io.open("/proc/version", "rb")
	if version_file ~= nil and string.find(version_file:read("*a"), "microsoft") then
		version_file:close()
		return true
	end
	return false
end

-- https://github.com/memoryInject/wsl-clipboard
if is_wsl() then
	vim.g.clipboard = {
		name = "wsl-clipboard",
		copy = {
			["+"] = "wcopy",
			["*"] = "wcopy",
		},
		paste = {
			["+"] = "wpaste",
			["*"] = "wpaste",
		},
		cache_enabled = true,
	}
end
