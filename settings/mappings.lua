local rocks_path = "/home/aqua/.local/share/nvim/rocks/share/lua/5.1/?.lua;"
rocks_path = rocks_path .. "/home/aqua/.local/share/nvim/rocks/share/lua/5.1/?/init.lua;"
local rocks_cpath = "/home/aqua/.local/share/nvim/rocks/lib/lua/5.1/?.so;"
rocks_cpath = rocks_cpath .. "/home/aqua/.local/share/nvim/rocks/lib64/lua/5.1/?.so;"
local aquamoon_path = '/home/aqua/.aquamoon/?.lua;/home/aqua/.aquamoon/?/?.lua;'

local lua_script = function(script_name)
	local script_path = "/home/aqua/.aquamoon/scripts/"
	return { "spawn", [['sh -c "lua ]] .. script_path .. script_name .. [[.lua"']] }
end
local terminal_app = function(app)
	return { "spawn", [['neovide term://"]] .. app .. [["']] }
end

-- RIVER
local mappings = {}
mappings.map = {
	normal = {
		-- Terminal
		{
			mod = { "Super" },
			key = "Return",
			command = { "spawn", [[ "neovide --no-tabs" ]] },
		},
		-- Browser
		{
			mod = { "Super", "Shift" },
			key = "Return",
			command = { "spawn", "qutebrowser -C ~/.aquamoon/qutebrowser.py" },
		},
		-- Launcher
		{
			mod = { "Super" },
			key = "D",
			command = lua_script("run"),
		},
		{
			mod = { "Super" },
			key = "Z",
			command = lua_script("system_menu"),
		},
		{
			mod = { "Super" },
			key = "W",
			command = lua_script("networkmanager"),
		},
		{
			mod = { "Super" },
			key = "T",
			command = lua_script("theme_picker"),
		},
		-- Brightness
		{
			mod = { "Super" },
			key = "V",
			command = lua_script("lower_brightness"),
		},
		{
			mod = { "Super" },
			key = "M",
			command = lua_script("raise_brightness"),
		},
		-- Volume
		{
			mod = { "Super" },
			key = "B",
			command = lua_script("lower_volume"),
		},
		{
			mod = { "Super" },
			key = "N",
			command = lua_script("raise_volume"),
		},
		-- Screenshot
		{
			mod = { "Super" },
			key = "S",
			command = lua_script("screenshot"),
		},
		-- Git
		{
			mod = { "Super" },
			key = "G",
			command = terminal_app("lazygit"),
		},
		-- Close
		{
			mod = "Super",
			key = "Q",
			command = "close",
		},
		-- Super+{J,K} to focus next/previous view in the layout stack
		{
			mod = { "Super", "Shift" },
			key = "J",
			command = { "focus-view", "previous" },
		},
		{
			mod = { "Super", "Shift" },
			key = "K",
			command = { "focus-view", "next" },
		},
		-- Super+Shift+{J,K} to rotate the layout stack
		{
			mod = "Super",
			key = "J",
			command = { "send-layout-cmd", "luatile", [[ "rotate(false)" ]] },
		},
		{
			mod = "Super",
			key = "K",
			command = { "send-layout-cmd", "luatile", [[ "rotate(true)" ]] },
		},
		-- Super+E to bump the focused view to the top of the layout stack
		{
			mod = "Super",
			key = "E",
			command = "zoom",
		},
		-- Super+F to toggle fullscreen
		{
			mod = "Super",
			key = "F",
			command = "toggle-fullscreen",
		},
		-- Super+{H,L} to decrease/increase the main_factor value of luatile by 0.02
		{
			mod = { "Super" },
			key = "H",
			command = { "send-layout-cmd", "luatile", [[ "modify_main_ratio(-1)" ]] },
		},
		{
			mod = { "Super" },
			key = "L",
			command = { "send-layout-cmd", "luatile", [[ "modify_main_ratio(1)" ]] },
		},
	},
}

-- mappings for pointer (mouse)
mappings["map-pointer"] = {
	normal = {
		-- Super + Left Mouse Button to move views
		{
			mod = "Super",
			key = "BTN_LEFT",
			command = "move-view",
		},
		-- Super + Right Mouse Button to resize views
		{
			mod = "Super",
			key = "BTN_RIGHT",
			command = "resize-view",
		},
	},
}


-- NVIM
mappings.nvim = {}

-- Window navigation mappings
mappings.nvim.window_nav = {
	{ "n", "<Left>",  "<c-w>h" },
	{ "n", "<Right>", "<c-w>l" },
	{ "n", "<Down>",  "<c-w>j" },
	{ "n", "<Up>",    "<c-w>k" },
}

-- Basic mappings
mappings.nvim.basic_mappings = {
	{ { "n", "x", "o" }, "<CR>", "<Plug>(leap)" },
	{ "n",               "U",    "<c-r>" }, -- redo
}

mappings.nvim.tv = {
	files = "<leader>f",
	text = "<leader>g",
	channels = "<leader>m",
}

-- Leader key mappings
mappings.nvim.leader_mappings = function(vim)
	return {
		-- left hand top row
		r = function() vim.cmd.terminal "scooter" end,
		e = function() vim.cmd.Oil() end,
		w = function() vim.cmd.terminal "fish" end,
		q = function() vim.cmd.bd() end,

		-- left hand home row
		d = function()
			vim.diagnostic.enable(not vim.diagnostic.is_enabled())
		end,

		-- left hand lower
		c = function()
			local cursor_row, cursor_col = unpack(vim.api.nvim_win_get_cursor(0))
			require("fidget").notify(
				"Row: " .. tostring(cursor_row) .. ", " ..
				"Col: " .. tostring(cursor_col)
			)
		end,

		-- right hand top
		y = function() vim.cmd "terminal clipse" end,
		i = function() vim.lsp.buf.hover() end,
		o = function() vim.cmd "terminal opencode" end,
		p = function() vim.cmd "terminal dunstctl history | bat" end, -- TODO parse json before displaying

		-- right hand center
		h = function() vim.cmd "LazyGitFilterCurrentFile" end,
		j = function() vim.g.neovide_scale_factor = vim.g.neovide_scale_factor - 0.1 end,
		k = function() vim.g.neovide_scale_factor = vim.g.neovide_scale_factor + 0.1 end,

		-- right hand bottom
		n = function() vim.cmd "terminal wiremix" end,
		["/"] = function() vim.cmd.noh() end
	}
end

-- Function key mappings
mappings.nvim.function_key_mappings = function(vim)
	return {
		-- right hand
		[1] = function() vim.cmd "LazyGit" end,
		[2] = vim.cmd.aqua_save, -- from init.lua
		[3] = function() vim.cmd.split "./" end,
		[4] = function() vim.cmd.vsplit "./" end,
		-- left hand
		[5] = vim.cmd.cprev,
		[6] = vim.cmd.cnext,
		[7] = function() require("snipe").open_buffer_menu() end,
		[8] = vim.cmd.aqua_run, -- from init.lua
	}
end
return mappings
