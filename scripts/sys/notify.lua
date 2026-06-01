-- Notification module for Aquamoon
-- Sends dunst notifications for tag changes, messages, and progress bars

local M = {}

local S = dofile(os.getenv("HOME") .. "/.aquamoon/scripts/sys/settings.lua")

M.tally = function(t)
	if current_tag ~= t then
		current_tag = t

		local flag_string = ""
		while t >= 1.0 do
			t = t / 2
			flag_string = flag_string .. " 󰈿"
		end

		if string.len(flag_string) > 20 then
			flag_string = tostring(string.len(flag_string) / 5) .. " " .. flag_string
		end

		os.execute("dunstify --timeout=1000" ..
			" --icon=''" ..
			" -h string:bgcolor:#" .. S.theme.background ..
			" -h string:fgcolor:#" .. S.theme.text_primary ..
			" -h string:frcolor:#" .. S.theme.text_primary ..
			" -h string:hlcolor:#" .. S.theme.text_primary ..
			" -h int:width:300" ..
			" --replace=9 '" .. flag_string .. "'")
	end
end

M.send = function(message)
	os.execute("dunstify --timeout=1000" ..
		" --icon=''" ..
		" -h string:bgcolor:#" .. S.theme.background ..
		" -h string:fgcolor:#" .. S.theme.text_primary ..
		" -h string:frcolor:#" .. S.theme.text_primary ..
		" -h string:hlcolor:#" .. S.theme.text_primary ..
		" -h int:width:600" ..
		" --replace=9 '" .. message .. "'")
end

M.bar = function(value, message)
	os.execute("dunstify --timeout=500 " ..
		" -h string:bgcolor:#" .. S.theme.background ..
		" -h string:fgcolor:#" .. S.theme.text_primary ..
		" -h string:frcolor:#" .. S.theme.text_primary ..
		" -h string:hlcolor:#" .. S.theme.text_primary ..
		" -h 'int:value:" .. value .. "' " .. message)
end

return M
