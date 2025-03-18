--------------------------
-- Default luakit theme --
--------------------------

local theme = {}

-- Default settings
theme.font = "24px FairiesevkaTerm Nerd Font Mono"
theme.fg = "#7FBBB3"
theme.bg = "#1E2326"

-- General colours
theme.success_fg = "#0f0"
theme.loaded_fg = "#33AADD"
theme.error_fg = "#FFF"
theme.error_bg = "#F00"

-- Warning colours
theme.warning_fg = "#F00"
theme.warning_bg = "#FFF"

-- Notification colours
theme.notif_fg = "#444"
theme.notif_bg = "#FFF"

-- Menu colours
theme.menu_fg = "#000"
theme.menu_bg = "#fff"
theme.menu_selected_fg = "#000"
theme.menu_selected_bg = "#FF0"
theme.menu_title_bg = "#fff"
theme.menu_primary_title_fg = "#f00"
theme.menu_secondary_title_fg = "#666"

theme.menu_disabled_fg = "#999"
theme.menu_disabled_bg = theme.menu_bg
theme.menu_enabled_fg = theme.menu_fg
theme.menu_enabled_bg = theme.menu_bg
theme.menu_active_fg = "#060"
theme.menu_active_bg = theme.menu_bg

-- Proxy manager
theme.proxy_active_menu_fg = "#000"
theme.proxy_active_menu_bg = "#FFF"
theme.proxy_inactive_menu_fg = "#888"
theme.proxy_inactive_menu_bg = "#FFF"

-- Statusbar specific
theme.sbar_fg = theme.fg
theme.sbar_bg = theme.bg

-- Downloadbar specific
theme.dbar_fg = "#fff"
theme.dbar_bg = "#000"
theme.dbar_error_fg = "#F00"

-- Input bar specific
theme.ibar_fg = theme.fg
theme.ibar_bg = theme.bg

-- Tab label
theme.tab_fg = theme.fg
theme.tab_bg = theme.bg
theme.tab_hover_bg = "#292929"
theme.tab_ntheme = "#ddd"
theme.selected_fg = theme.fg
theme.selected_bg = "#3C4841"
theme.selected_ntheme = "#ddd"
theme.loading_fg = theme.fg 
theme.loading_bg = theme.bg 

theme.selected_private_tab_bg = "#3d295b"
theme.private_tab_bg = "#22254a"

-- Trusted/untrusted ssl colours
theme.trust_fg = "#0F0"
theme.notrust_fg = "#F00"

-- Follow mode hints
theme.hint_font = "24px FairiesevkaTerm Nerd Font Mono"
theme.hint_fg = theme.fg
theme.hint_bg = theme.bg
theme.hint_border = "1px dashed #000"
theme.hint_opacity = "0.3"
theme.hint_overlay_bg = theme.bg
theme.hint_overlay_border = "1px dotted #000"
theme.hint_overlay_selected_bg = "rgba(0,255,0,0.3)"
theme.hint_overlay_selected_border = theme.hint_overlay_border

-- General colour pairings
theme.ok = { fg = theme.fg, bg = theme.bg }
theme.warn = { fg = "#F00", bg = "#FFF" }
theme.error = { fg = "#FFF", bg = "#F00" }

-- Gopher page style (override defaults)
theme.gopher_light = { bg = "#E8E8E8", fg = "#17181C", link = "#03678D" }
theme.gopher_dark = { bg = "#17181C", fg = "#E8E8E8", link = "#f90" }

return theme

-- vim: et:sw=4:ts=8:sts=4:tw=80
