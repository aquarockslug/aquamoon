local M = {}

local function edit(relative)
	return function()
		vim.cmd.edit(vim.fn.fnameescape(vim.fn.stdpath("config") .. "/" .. relative))
	end
end

local function tv_channel(name)
	return function()
		local ok, tv = pcall(require, "tv")
		if ok then
			if name then tv.tv_channel(name) else tv.tv_channels() end
		end
	end
end

function M.setup()
	local s = require("mini.starter")
	s.setup({
		autoopen = true,
		header = "        ☾\n     AQUAMOON\n river · lua · neovim",
		footer = "",
		items = {
			{
				{ name = "Open file",   action = tv_channel("files"), section = "Start" },
				{ name = "Search text", action = tv_channel("text"),  section = "Start" },
				{ name = "TV channels", action = tv_channel(),        section = "Start" },
			},
			{
				{ name = "Search files",       action = tv_channel("aquamoon"),            section = "Aquamoon" },
				{ name = "River keybindings",  action = edit("toml/river-bindings.toml"),  section = "Aquamoon" },
				{ name = "Neovim keybindings", action = edit("toml/neovim-bindings.toml"), section = "Aquamoon" },
				{ name = "Aquamoon options",   action = edit("toml/aquamoon.toml"),        section = "Aquamoon" },
				{ name = "Noctalia options",   action = edit("toml/noctalia.toml"),        section = "Aquamoon" },
			},
			s.sections.recent_files(8, false),
			s.sections.builtin_actions(),
		},
		content_hooks = {
			s.gen_hook.adding_bullet("▸ "),
			s.gen_hook.indexing("all", { "Builtin actions" }),
			s.gen_hook.aligning("center", "center"),
		},
		query_updaters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_-. ",
	})
end

return M
