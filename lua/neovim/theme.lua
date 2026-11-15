local M = {}

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

local colorscheme_fonts = {
	["flume-mira"] = "BigBlueTermPlus Nerd Font Mono",
	["flume-opal"] = "BigBlueTermPlus Nerd Font Mono",
	["moonfly"] = "BigBlueTermPlus Nerd Font Mono",
	["archery"] = "BigBlueTermPlus Nerd Font Mono",
}

local function default_font()
	local noctalia = require("neovim.toml").load("noctalia.toml")
	return (noctalia.shell or {}).font_family or "FairiesevkaTerm Nerd Font Mono"
end

function M.apply_font(colorscheme)
	if not vim.g.neovide then
		return
	end
	local name = colorscheme or vim.g.colors_name or fallback_colorscheme
	local font = colorscheme_fonts[name] or default_font()
	vim.o.guifont = font:find(":h%d+") and font or (font .. ":h16")
end

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

local source_keys = {
	custom = "custom_palette",
	community = "community_palette",
	builtin = "builtin",
}

local function noctalia_palette()
	local theme = {}
	local config_dir = vim.fn.stdpath("config") .. "/toml"
	read_theme(config_dir .. "/theme.toml", theme)
	read_theme(config_dir .. "/noctalia.toml", theme)
	read_theme((vim.env.XDG_STATE_HOME or vim.fn.expand("~/.local/state")) .. "/noctalia/settings.toml", theme)
	local key = source_keys[theme.source]
	return key and theme[key] or nil
end

function M.apply()
	local entry = palette_colorschemes[noctalia_palette() or ""]
	if entry then
		vim.o.background = entry[2]
		if pcall(vim.cmd.colorscheme, entry[1]) then
			M.apply_font(entry[1])
			return
		end
	end
	if vim.g.colors_name == nil then
		vim.o.background = "dark"
		pcall(vim.cmd.colorscheme, fallback_colorscheme)
	end
	M.apply_font(vim.g.colors_name)
end

function M.setup()
	if vim.g.neovide then
		vim.g.neovide_opacity = 0.9
		vim.api.nvim_create_autocmd("ColorScheme", {
			group = vim.api.nvim_create_augroup("aquamoon_neovide_font", { clear = true }),
			callback = function(event) M.apply_font(event.match) end,
		})
	end

	M.apply()
	_G.noctalia_theme_signal = vim.uv.new_signal()
	_G.noctalia_theme_signal:start("sigusr1", vim.schedule_wrap(M.apply))
end

return M
