R = require 'river'

-- override the theme in settings if one was pass through an arg
if arg[1] ~= nil then
	S = require('settings').get(arg[1])
else
	S = require('settings').get("sweetie")
end

-- TODO theme_name -> settings

-- TODO send active theme to tofi by key mapping it with send-layout-cmd
-- write the active theme to a file so that nvim and tofi can read it?
-- pass settings through run and save it in the layout?

R.apply_settings(S)

R.run()
