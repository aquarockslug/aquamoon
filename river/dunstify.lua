-- use a variable to check if the current tag has changed
local S = require("settings")
return function(t)
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
			" --replace=9 '" .. flag_string .. "'")
	end
end
