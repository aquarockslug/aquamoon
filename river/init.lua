R = require 'river'

-- override the theme in settings if one was pass through an arg
if arg[1] ~= nil then
	local s = require('settings')
	s.theme = require('settings/theme').get(arg[1])
	S = s
else
	S = require('settings')
end

R.apply_settings(S)

R.run()
