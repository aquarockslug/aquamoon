local mappings = {}
mappings.map = {
	normal = {
		-- Terminal
		{
			mod = { "Super" },
			key = "Return",
			command = { "spawn", [[ 'neovide --no-multigrid --no-tabs' ]] },
		},
		-- Browser
		{
			mod = { "Super", "Shift" },
			key = "Return",
			command = { "spawn", "glide-bin" },
		},
		-- Launcher
		{
			mod = { "Super" },
			key = "D",
			command = { "spawn", [[ 'sh -c "lua /home/aqua/.aquamoon/etc/drun.lua"' ]] },
		},
		{
			mod = { "Super" },
			key = "Z",
			command = { "spawn", [[ 'sh -c "lua /home/aqua/.aquamoon/etc/system_menu.lua"' ]] },
		},
		{
			mod = { "Super" },
			key = "W",
			command = { "spawn", [[ 'sh -c "lua /home/aqua/.aquamoon/etc/networkmanager.lua"' ]] },
		},
		{
			mod = { "Super" },
			key = "T",
			command = { "spawn", [[ 'sh -c "lua /home/aqua/.aquamoon/etc/theme_picker.lua"' ]] },
		},
		-- Volume
		{
			mod = { "Super" },
			key = "C",
			command = { "spawn", [[ 'sh -c "lua /home/aqua/.aquamoon/etc/lower_volume.lua"' ]] },
		},
		{
			mod = { "Super" },
			key = "V",
			command = { "spawn", [[ 'sh -c "lua /home/aqua/.aquamoon/etc/raise_volume.lua"' ]] },
		},
		-- Brightness
		{
			mod = { "Super" },
			key = "N",
			command = { "spawn", [[ 'sh -c "lua /home/aqua/.aquamoon/etc/lower_brightness.lua"' ]] },
		},
		{
			mod = { "Super" },
			key = "M",
			command = { "spawn", [[ 'sh -c "lua /home/aqua/.aquamoon/etc/raise_brightness.lua"' ]] },
		},
		-- Screenshot
		{
			mod = { "Super" },
			key = "S",
			command = { "spawn", [[ 'sh -c "lua /home/aqua/.aquamoon/etc/screenshot.lua"' ]] },
		},
		-- TODO
		-- -- Show Notifications
		-- {
		-- 	mod = "Super",
		-- 	key = "N",
		-- 	command = { "spawn", [['swaync-client -t']] },
		-- },
		-- Super+Q to close the focused view
		{
			mod = "Super",
			key = "Q",
			command = "close",
		},
		-- Super+{J,K} to focus next/previous view in the layout stack
		{
			mod = "Super",
			key = "J",
			command = { "focus-view", "previous" },
		},
		{
			mod = "Super",
			key = "K",
			command = { "focus-view", "next" },
		},
		-- Super+Shift+{J,K} to swap focused view with the next/previous view in the layout stack
		{
			mod = { "Super", "Shift" },
			key = "J",
			command = { "swap", "previous" },
		},
		{
			mod = { "Super", "Shift" },
			key = "K",
			command = { "swap", "next" },
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

return mappings
