-- Get CPU temperature from thermal zones and output JSON for status bar

local M = {}

local S = dofile(os.getenv("HOME") .. "/.aquamoon/scripts/sys/settings.lua")
local notify = dofile(S.path .. "/scripts/sys/notify.lua")

local preferred_types = { "x86_pkg_temp", "core", "cpu", "package id 0", "Tctl" }

local function read_file(path)
	local file = io.open(path, "r")
	if not file then return nil end
	local content = file:read("*l")
	file:close()
	return content
end

local function contains(str, keyword)
	return str:lower():find(keyword:lower(), 1, true) ~= nil
end

-- First pass: try preferred types
local handle = io.popen("ls -d /sys/class/thermal/thermal_zone* 2>/dev/null")
if handle then
	for zone in handle:lines() do
		local type_val = read_file(zone .. "/type")
		local temp_str = read_file(zone .. "/temp")
		if type_val and temp_str then
			for _, kw in ipairs(preferred_types) do
				if contains(type_val, kw) and temp_str:match("^%d+$") and tonumber(temp_str) > 1000 then
					local celsius = math.floor(tonumber(temp_str) / 1000)
					notify.send(string.format(' %d°C', celsius))
					return M
				end
			end
		end
	end
	handle:close()
end

-- Fallback: any readable temp above 30°C
handle = io.popen("ls -d /sys/class/thermal/thermal_zone* 2>/dev/null")
if handle then
	for zone in handle:lines() do
		local temp_str = read_file(zone .. "/temp")
		if temp_str and temp_str:match("^%d+$") and tonumber(temp_str) > 30000 then
			local celsius = math.floor(tonumber(temp_str) / 1000)
			notify.send(string.format('{"text": " %d°C", "tooltip": "Fallback zone: %s"}', celsius, zone))
			return M
		end
	end
	handle:close()
end

-- Final fallback
notify.send('{"text": "N/A", "tooltip": "No valid CPU thermal zone found"}')

return M
