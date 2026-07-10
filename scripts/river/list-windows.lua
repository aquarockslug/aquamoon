-- List windows via lswt and send a notification

local M = {}

local S = dofile(os.getenv("HOME") .. "/.aquamoon/scripts/sys/settings.lua")
local notify = dofile(S.path .. "/scripts/sys/notify.lua")

local handle = io.popen("lswt")
local windows = {}

if handle then
	for line in handle:lines() do
		local app_id = line:match("^%S+%s+(.+)$")
		if app_id then
			app_id = app_id:gsub('^"(.*)"$', '%1')
			table.insert(windows, app_id)
		end
	end
	handle:close()
end

if #windows == 0 then
	notify.send("󰈿 No windows open")
else
	table.sort(windows, function(a, b) return #a < #b end)
	local msg = table.concat(windows, "\n")
	notify.send(msg)
end

return M
