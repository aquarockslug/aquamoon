package.path = package.path .. ";" .. os.getenv("HOME") .. "/.aquamoon/?.lua"
package.path = package.path .. ";" .. os.getenv("HOME") .. "/.aquamoon/scripts/sys/?.lua"
local S = require("scripts/sys/settings")
local tofi = require("scripts/sys/tofi").opener.options(S.theme.tofi)
local notify = require("scripts/sys/notify")

local handle = io.popen("lswt -c \"ita\"")
local windows = {}

if handle then
	for line in handle:lines() do
		local id, title, app_id = line:match("^([^,]+),(.*),([^,]+)$")
		if id and app_id then
			title = title or ""
			table.insert(windows, { id = id, title = title, app_id = app_id })
		end
	end
	handle:close()
end

if #windows == 0 then
	notify.send("No windows open")
	return
end

table.sort(windows, function(a, b) return #a.title < #b.title end)

local choices = {}
for _, w in ipairs(windows) do
	local display = w.title ~= "" and w.title or w.app_id
	table.insert(choices, { name = display, value = w })
end

local chosen = tofi.choices(choices).open()

if not chosen then
	return
end

local app_id = chosen.app_id
local title = chosen.title
local escaped_title = title:gsub("'", "'\\''")
local cmd = "wlrctl toplevel focus app_id:" .. app_id
if title ~= "" then
	cmd = cmd .. " title:'" .. escaped_title .. "'"
end
os.execute(cmd)
