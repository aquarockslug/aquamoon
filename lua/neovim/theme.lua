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

-- Neovide font per colorscheme. Entries without ":h<size>" default to ":h16".
-- Unlisted colorschemes fall back to the shell font_family in toml/noctalia.toml.
local default_font_size = 16
local colorscheme_fonts = {
	["sweetie"] = "FairiesevkaTerm Nerd Font Mono",
	["bluloco-dark"] = "FairiesevkaTerm Nerd Font Mono",
	["bluloco-light"] = "FairiesevkaTerm Nerd Font Mono",
	["flume-dusk"] = "FairiesevkaTerm Nerd Font Mono",
	["flume-mesa"] = "FairiesevkaTerm Nerd Font Mono",
	["flume-mira"] = "BigBlueTermPlus Nerd Font Mono",
	["flume-opal"] = "BigBlueTermPlus Nerd Font Mono",
	["moonfly"] = "BigBlueTermPlus Nerd Font Mono",
	["archery"] = "BigBlueTermPlus Nerd Font Mono",
}

local function format_guifont(font)
	if font:find(":h%d+") then
		return font
	end
	return string.format("%s:h%d", font, default_font_size)
end

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
	vim.o.guifont = format_guifont(font)
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
			M.apply_font(entry[1])
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
	M.apply_font(vim.g.colors_name)
end

function M.setup()
	if vim.g.neovide then
		vim.g.neovide_opacity = 0.9
		vim.api.nvim_create_autocmd("ColorScheme", {
			group = vim.api.nvim_create_augroup("aquamoon_neovide_font", { clear = true }),
			callback = function(event)
				M.apply_font(event.match)
			end,
		})
	end

	M.apply()
	_G.noctalia_theme_signal = vim.uv.new_signal()
	_G.noctalia_theme_signal:start("sigusr1", vim.schedule_wrap(M.apply))
end

return M
