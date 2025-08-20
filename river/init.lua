R = require 'river'
local createSettings = require 'settings'

-- TODO local set_by_clock = theme_list[math.ceil(tonumber(os.date("%H")) / 24 * 3)]
local theme = require("settings/theme").get("sweetie")

settings = createSettings(theme)

-- local drun = require 'etc/drun'
-- drun(S.theme.name)

R.apply_settings(settings)

R.run()
