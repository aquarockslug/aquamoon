R = require 'river'
S = require 'settings'
local themes = require 'settings/theme'

if arg[1] ~= nil then
	S.theme = themes.get(arg[1])
else
	-- TODO local set_by_clock = theme_list[math.ceil(tonumber(os.date("%H")) / 24 * 3)]
	S.theme = themes.get("sweetie")
end

-- local drun = require 'etc/drun'
-- drun(S.theme.name)

R.apply_settings(S)

R.run()
