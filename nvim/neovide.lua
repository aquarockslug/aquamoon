-- NEOVIDE CONFIGURATION
if vim.g.neovide then
	vim.g.neovide_opacity = S.theme.opacity
	vim.o.guifont = S.theme.active_font.name
	vim.g.neovide_text_gamma = 0.8
	vim.g.neovide_text_contrast = 0.1
	vim.g.neovide_padding_left = 10
	vim.g.neovide_padding_top = 10
	vim.opt.linespace = 3

	if S.theme_name == "OceanicNext" or S.theme_name == "minicyan" then
		vim.g.neovide_cursor_vfx_mode = "torpedo"
	end
	if S.theme_name == "srcery" or S.theme_name == "eldritch" then
		vim.g.neovide_cursor_vfx_mode = "pixiedust"
	end
end