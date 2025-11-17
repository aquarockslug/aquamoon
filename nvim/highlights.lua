local theme = require "settings".theme

-- TODO use a loop here
-- for key, func in pairs({

vim.cmd.highlight("LineNr guibg=#" .. theme.bg)
vim.cmd.highlight("LineNr guifg=#" .. theme.fg)
vim.cmd.highlight("LineNrAbove guifg=#" .. theme.fg)
vim.cmd.highlight("LineNrBelow guifg=#" .. theme.fg)
vim.cmd.highlight("CursorLineNr guifg=#" .. theme.fg)

vim.cmd.highlight("OilDir guifg=#" .. theme.fg)

vim.cmd.highlight("LazyGitFloat guifg=#" .. theme.fg2)
vim.cmd.highlight("LazyGitBorder guifg=#" .. theme.fg)

vim.cmd.highlight("MiniStarterSection guifg=#" .. theme.fg)
vim.cmd.highlight("MiniStarterItemPrefix guifg=#" .. theme.accent)
vim.cmd.highlight("MiniStarterQuery guifg=#" .. theme.accent)
