-- use a variable to check if the current tag has changed
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

		-- TODO get the color info from the theme file
		os.execute("dunstify --timeout=1000 --appname=luatile " ..
			"-h string:bgcolor:#2a2a3a " ..
			"-h string:fgcolor:#92d3c5 " ..
			"-h string:frcolor:#92d3c5 " ..
			"--replace=9 '" .. flag_string .. "'")
	end
end
