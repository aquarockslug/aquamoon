-- Notifications for the aquamoon2-river branch
--
-- Noctalia owns org.freedesktop.Notifications (see toml/startup.toml), so the
-- helpers below talk to the running shell instead of spawning dunstify. The
-- colours come from the active Noctalia theme.

local function quote(value)
	return "'" .. tostring(value):gsub("'", "'\\''") .. "'"
end

local function show(summary, body)
	os.execute("noctalia msg notification-show " .. quote(summary) .. " " .. quote(body)
		.. " >/dev/null 2>&1")
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

		show("Workspaces", flag_string)
	end
end

local function send(message)
	show("aquamoon2", message)
end

local function bar(value, message)
	show(message, string.format("%d%%", value))
end

return {
	tally = tally,
	send = send,
	bar = bar,
}
