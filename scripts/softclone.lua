#!/usr/bin/lua5.4

local picker = io.popen("ssh soft repo list | peco")
local result = picker:read()
if result then
	lush.exec("git clone ssh://soft/" .. result)
end
picker:close()
