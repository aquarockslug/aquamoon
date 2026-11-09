local M = {}

-- Neovim follows the shell palette by switching to the matching colorscheme
-- plugin. Palettes without an installed plugin keep the current colorscheme.
local fallback_colorscheme = "sweetie"
local palette_colorschemes = {
	["Bluloco Dark"] = { "bluloco-dark", "dark" },
	["Bluloco Light"] = { "bluloco-light", "light" },
	["Sweetie"] = { "sweetie", "dark" },
	["Moonfly"] = { "moonfly", "dark" },
	["Flume Dusk"] = { "flume-dusk", "dark" },
	["Flume Mesa"] = { "flume-mesa", "light" },
	["Flume Mira"] = { "flume-mira", "dark" },
	["Flume Opal"] = { "flume-opal", "light" },
	["Archery"] = { "archery", "dark" },
}

local function read_theme(path, theme)
	local ok, lines = pcall(vim.fn.readfile, path)
	if not ok then
		return
	end
	local in_theme = false
	for _, line in ipairs(lines) do
		if line:match("^%s*%[") then
			in_theme = line:match("^%s*%[theme%]%s*$") ~= nil
		elseif in_theme then
			local key, value = line:match('^%s*([%w_]+)%s*=%s*"(.-)"%s*$')
			if key then
				theme[key] = value
			end
		end
	end
end

local function noctalia_palette()
	local theme = {}
	local config_dir = vim.fn.stdpath("config") .. "/toml"
	read_theme(config_dir .. "/theme.toml", theme)
	read_theme(config_dir .. "/noctalia.toml", theme)
	local state = vim.env.XDG_STATE_HOME or vim.fn.expand("~/.local/state")
	read_theme(state .. "/noctalia/settings.toml", theme)

	local key
	if theme.source == "custom" then
		key = "custom_palette"
	elseif theme.source == "community" then
		key = "community_palette"
	elseif theme.source == "builtin" then
		key = "builtin"
	else
		return nil
	end
	return theme[key]
end

function M.apply()
	local entry = palette_colorschemes[noctalia_palette() or ""]
	if entry then
		vim.o.background = entry[2]
		local ok = pcall(function()
			vim.cmd.colorscheme(entry[1])
		end)
		if ok then
			return
		end
	end
	-- No matching plugin palette: keep the active colorscheme, or fall back
	-- to the default on startup.
	if vim.g.colors_name == nil then
		vim.o.background = "dark"
		pcall(function()
			vim.cmd.colorscheme(fallback_colorscheme)
		end)
	end
end

function M.setup()
	M.apply()
	_G.noctalia_theme_signal = vim.uv.new_signal()
	_G.noctalia_theme_signal:start("sigusr1", vim.schedule_wrap(M.apply))

	if vim.g.neovide then
		vim.g.neovide_opacity = 0.9
		local noctalia = require("neovim.toml").load("noctalia.toml")
		local font = (noctalia.shell or {}).font_family or "FairiesevkaTerm Nerd Font Mono"
		vim.o.guifont = font .. ":h16"
	end
end

return M
