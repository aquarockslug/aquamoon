package.path = '/home/aqua/.aquamoon/?.lua;/home/aqua/.aquamoon/?/?.lua'

require 'settings'
require 'zsh/zshrc'

local cmd = ""
if arg[1] then
	cmd = arg[1]
end
print(cmd)

os.execute("foot " ..
	'--override="font=BigBlueTermPlus Nerd Font Mono:size=7" ' .. -- TODO get this from settings
	'--override="colors.alpha=0.5" ' ..
	'--override="dpi-aware=true" ' ..
	'--override="title=Terminal" ' ..
	cmd
)
