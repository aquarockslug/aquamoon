local mappings = {}
mappings.map = {
	normal = {
		-- Terminal
		{
			mod = { "Super" },
			key = "Return",
			command = { "spawn", "wezterm" },
		},
		-- Browser
		{
			mod = { "Super", "Control" },
			key = "Return",
			command = { "spawn", "firefox" },
		},
		-- Laucher
		{
			mod = { "Super" },
			key = "D",
			command = { "spawn", "nwg-drawer" },
		},
		-- Show Notifications
		{
			mod = "Super",
			key = "N",
			command = { "spawn", [['swaync-client -t']] },
		},
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
		-- Super+{H,L} to decrease/increase the main_factor value of rivertile by 0.02
		{
			mod = "Super",
			key = "H",
			command = { "send-layout-cmd", "rivertile", [['main-ratio -0.02']] },
		},
		{
			mod = "Super",
			key = "L",
			command = { "send-layout-cmd", "rivertile", [['main-ratio +0.02']] },
		},
		-- Super+Shift+{H,L} to increment/decrement the main_count value of rivertile
		{
			mod = { "Super", "Shift" },
			key = "H",
			command = { "send-layout-cmd", "rivertile", [['main-count +1']] },
		},
		{
			mod = { "Super", "Shift" },
			key = "L",
			command = { "send-layout-cmd", "rivertile", [['main-count -1']] },
		},
		-- Control+Alt+{H,J,K,L} to change layout orientation
		{
			mod = { "Control", "Alt" },
			key = "H",
			command = { "send-layout-cmd", "rivertile", [['main-location left']] },
		},
		{
			mod = { "Control", "Alt" },
			key = "J",
			command = { "send-layout-cmd", "rivertile", [['main-location bottom']] },
		},
		{
			mod = { "Control", "Alt" },
			key = "K",
			command = { "send-layout-cmd", "rivertile", [['main-location top']] },
		},
		{
			mod = { "Control", "Alt" },
			key = "L",
			command = { "send-layout-cmd", "rivertile", [['main-location right']] },
		},
		-- Super+Alt+{H,J,K,L} to move views (floating)
		{
			mod = { "Super", "Alt" },
			key = "H",
			command = { "move", "left", 100 },
		},
		{
			mod = { "Super", "Alt" },
			key = "J",
			command = { "move", "down", 100 },
		},
		{
			mod = { "Super", "Alt" },
			key = "K",
			command = { "move", "up", 100 },
		},
		{
			mod = { "Super", "Alt" },
			key = "L",
			command = { "move", "right", 100 },
		},
		-- Super+Control+{H,J,K,L} to resize views
		{
			mod = { "Super", "Control" },
			key = "H",
			command = { "resize", "horizontal", -100 },
		},
		{
			mod = { "Super", "Control" },
			key = "J",
			command = { "resize", "vertical", 100 },
		},
		{
			mod = { "Super", "Control" },
			key = "K",
			command = { "resize", "vertical", -100 },
		},
		{
			mod = { "Super", "Control" },
			key = "L",
			command = { "resize", "horizontal", 100 },
		},
		-- Super+Space to toggle float
		{
			mod = "Super",
			key = "Space",
			command = "toggle-float",
		},
		-- Super+F to toggle fullscreen
		{
			mod = "Super",
			key = "F",
			command = "toggle-fullscreen",
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
