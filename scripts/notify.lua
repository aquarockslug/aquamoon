-- use a variable to check if the current tag has changed
local S = require("settings")
local M = {}

M.tally = function(t)
	if current_tag ~= t then
		current_tag = t

		-- add to flag string every time we divide by two until it is 1
		local flag_string = ""
		while t >= 1.0 do
			t = t / 2
			flag_string = flag_string .. " 󰈿"
		end

		-- show numbers if there are more than 4 flags
		if string.len(flag_string) > 20 then
			flag_string = tostring(string.len(flag_string) / 5) .. " " .. flag_string
		end

		os.execute("dunstify --timeout=1000 --appname=luatile " ..
			" --icon=''" .. -- no icon
			" -h string:bgcolor:#" .. S.theme.bg ..
			" -h string:fgcolor:#" .. S.theme.fg ..
			" -h string:frcolor:#" .. S.theme.fg ..
			" -h string:hlcolor:#" .. S.theme.fg ..
			" -h int:width:300" ..
			" --replace=9 '" .. flag_string .. "'")
	end
end
M.send = function(message)
	os.execute("dunstify" ..
		" --icon=''" .. -- no icon
		" -h string:bgcolor:#" .. S.theme.bg ..
		" -h string:fgcolor:#" .. S.theme.fg ..
		" -h string:frcolor:#" .. S.theme.fg ..
		" -h string:hlcolor:#" .. S.theme.fg ..
		" -h int:width:600" ..
		" --replace=9 '" .. message .. "'")
end
M.bar = function(value, message)
	os.execute("dunstify --timeout=500 " ..
		" -h string:bgcolor:#" .. S.theme.bg ..
		" -h string:fgcolor:#" .. S.theme.fg ..
		" -h string:frcolor:#" .. S.theme.fg ..
		" -h string:hlcolor:#" .. S.theme.fg ..
		" -h 'int:value:" .. value .. "' " .. message)

	-- os.execute("dunstify -h 'int:value:" .. value .. "' " .. message)
end
return M
