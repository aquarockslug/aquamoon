local function apply_theme(theme)
	local highlights = {
		LineNr = { bg = theme.background, fg = theme.text_primary },
		LineNrAbove = { fg = theme.text_primary },
		LineNrBelow = { fg = theme.text_primary },
		CursorLineNr = { fg = theme.text_primary },
		OilDir = { fg = theme.text_primary },
		LazyGitBorder = { fg = theme.text_primary },
		MiniStarterSection = { fg = theme.text_primary },
		MiniStarterItemPrefix = { fg = theme.accent },
		MiniStarterQuery = { fg = theme.accent },
		Cursor = { bg = theme.text_primary, fg = theme.background },
		lCursor = { bg = theme.text_primary, fg = theme.background },
		CursorIM = { bg = theme.accent, fg = theme.background },
	}
	for group, colors in pairs(highlights) do
		local attrs = {}
		if colors.bg then table.insert(attrs, "guibg=#" .. colors.bg) end
		if colors.fg then table.insert(attrs, "guifg=#" .. colors.fg) end
		vim.cmd.highlight(group .. " " .. table.concat(attrs, " "))
	end

	if vim.g.neovide then
		vim.g.neovide_opacity = theme.opacity
		vim.o.guifont = theme.active_font.name
		vim.g.neovide_text_gamma = 0.8
		vim.g.neovide_text_contrast = 0.1
		vim.g.neovide_padding_left = 10
		vim.g.neovide_padding_top = 10
		vim.opt.linespace = 3
	end
end

local function reload_theme()
	local TT = require("scripts/sys/tinytoml")
	local rocks = TT.parse(os.getenv("HOME") .. "/.aquamoon/rocks.toml")
	local theme_name = rocks.config.colorscheme:gsub("-", "_")
	local theme = TT.parse(os.getenv("HOME") .. "/.aquamoon/toml/themes/" .. theme_name .. ".toml")
	if theme.colorscheme then
		vim.cmd("colorscheme " .. theme.colorscheme)
	end
	apply_theme(theme)
end

return {
	apply_theme = apply_theme,
	reload_theme = reload_theme,
}
