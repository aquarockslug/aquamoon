-- HIGHLIGHTS
local theme = require "settings".theme

local highlights = {
	LineNr = { bg = theme.bg, fg = theme.fg },
	LineNrAbove = { fg = theme.fg },
	LineNrBelow = { fg = theme.fg },
	CursorLineNr = { fg = theme.fg },
	OilDir = { fg = theme.fg },
	LazyGitFloat = { fg = theme.fg2 },
	LazyGitBorder = { fg = theme.fg },
	MiniStarterSection = { fg = theme.fg },
	MiniStarterItemPrefix = { fg = theme.accent },
	MiniStarterQuery = { fg = theme.accent },
	Cursor = { bg = theme.fg, fg = theme.bg },
	lCursor = { bg = theme.fg, fg = theme.bg },
	CursorIM = { bg = theme.accent, fg = theme.bg },
}

for group, colors in pairs(highlights) do
	local attrs = {}
	if colors.bg then table.insert(attrs, "guibg=#" .. colors.bg) end
	if colors.fg then table.insert(attrs, "guifg=#" .. colors.fg) end
	vim.cmd.highlight(group .. " " .. table.concat(attrs, " "))
end
