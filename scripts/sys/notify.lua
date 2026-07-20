local S = require("scripts/sys/settings")

local function dunstify(extra, message)
	os.execute("dunstify" ..
		" -h string:bgcolor:#" .. S.theme.background ..
		" -h string:fgcolor:#" .. S.theme.text_primary ..
		" -h string:frcolor:#" .. S.theme.text_primary ..
		" -h string:hlcolor:#" .. S.theme.text_primary ..
		" " .. extra ..
		" '" .. message .. "'")
end

local current_tag

local function tally(t)
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

		dunstify("--timeout=1000 --icon='' -h int:width:300 --replace=9", flag_string)
	end
end

local function send(message)
	dunstify("--timeout=1000 --icon='' -h int:width:600 --replace=9", message)
end

local function bar(value, message)
	dunstify("--timeout=500 -h 'int:value:" .. value .. "'", message)
end

return {
	tally = tally,
	send = send,
	bar = bar,
}
