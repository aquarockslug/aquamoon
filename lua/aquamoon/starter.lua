local M = {}

local function starter()
	return require("mini.starter")
end

local function config_root()
	return vim.fn.stdpath("config")
end

local function edit(relative)
	return function()
		vim.cmd.edit(vim.fn.fnameescape(config_root() .. "/" .. relative))
	end
end

local function tv_channel(name)
	return function()
		local ok, tv = pcall(require, "tv")
		if not ok then
			vim.notify("tv.nvim is not available", vim.log.levels.WARN)
			return
		end
		tv.tv_channel(name)
	end
end

local function header()
	return table.concat({
		"        ☾",
		"     AQUAMOON",
		" river · lua · neovim",
	}, "\n")
end

local function footer()
	return table.concat({
		"<CR> select   <C-c> close   <BS> erase   <Esc> reset",
		"Up/Down or <C-n>/<C-p> move",
	}, "\n")
end

local function items()
	local s = starter()
	return {
		{
			{ name = "Open file", action = tv_channel("files"), section = "Start" },
			{ name = "Search text", action = tv_channel("text"), section = "Start" },
		},
		{
			{
				name = "Aquamoon keybindings",
				action = edit("toml/aquamoon.toml"),
				section = "Aquamoon",
			},
			{
				name = "Aquamoon theme",
				action = edit("toml/noctalia.toml"),
				section = "Aquamoon",
			},
			{
				name = "Window manager",
				action = edit("wm/wm.lua"),
				section = "Aquamoon",
			},
			{
				name = "Neovim config",
				action = edit("init.lua"),
				section = "Aquamoon",
			},
			{
				name = "README",
				action = edit("README.md"),
				section = "Aquamoon",
			},
			{
				name = "Plugin lockfile",
				action = edit("nvim-pack-lock.json"),
				section = "Aquamoon",
			},
		},
		s.sections.recent_files(8, false),
		s.sections.builtin_actions(),
	}
end

function M.setup()
	local s = starter()
	s.setup({
		autoopen = true,
		items = items(),
		header = header,
		footer = footer,
		content_hooks = {
			s.gen_hook.adding_bullet("▸ "),
			s.gen_hook.indexing("all", { "Builtin actions" }),
			s.gen_hook.aligning("center", "center"),
		},
		query_updaters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_-. ",
	})
end

return M
