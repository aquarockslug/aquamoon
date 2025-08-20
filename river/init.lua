R = require 'river'
S = require 'settings'
local themes = require 'settings/theme'

if arg[1] ~= nil then
	S.theme = themes.get(arg[1])
end

-- local drun = require 'etc/drun'
-- drun(S.theme.name)

R.apply_settings(S)

R.run()
