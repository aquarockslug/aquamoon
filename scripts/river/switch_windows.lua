-- use a tofi menu to pick a window and display the chosen window on the screen

package.path = package.path .. ";" .. os.getenv("HOME") .. "/.aquamoon/scripts/sys/?.lua"
local menu = require("tofi").opener.options(require("settings").theme.tofi)

local handle = io.popen("lswt")
local windows = {}

if handle then
	for line in handle:lines() do
		local title = line:match("^%S+%s+(.+)$")
		if title then
			title = title:gsub('^"(.*)"$', '%1')
			table.insert(windows, title)
		end
	end
	handle:close()
end
table.sort(windows, function(a, b) return #a < #b end)

local choices = {}
for _, window in pairs(windows) do
	local c = { name = window, value = window }
	table.insert(choices, c)
end

-- .open() returns the value of the choice that was chosen on the menu
local chosen_title = menu.choices(choices).open()

-- TODO use riverctl to find the tag of the choosen window and display that tag on the screen
return chosen_title
