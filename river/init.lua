R = require 'river'
S = require 'settings'
local themes = require 'settings/theme'

-- override the theme in settings if one was pass through an arg
if arg[1] ~= nil then
	S.theme = S.theme.get(arg[1])
end

-- TODO theme_name -> settings

-- write the active theme to a file so that nvim and tofi can use it?
-- pass settings through run and save it in the layout?

R.apply_settings(S)

R.run()
