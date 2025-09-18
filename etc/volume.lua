-- TODO
local function get_volume(audio_sink)
	return 0.01
end

local function adjust(audio_sink, amount)
	local curr_volume = get_volume(audio_sink)
	local new_volume = curr_volume + (amount / 1000)
	print(curr_volume, new_volume)

	-- os.execute("pactl set-sink-volume " .. str(audio_sink) .. " " .. str(new_volume))

	-- TODO dont use wobpipe, instead convert decimal to bytes and pass to wob?
	-- TODO "tail -f /tmp/wobpipe | wob"

	os.execute("echo " .. new_volume .. " > /tmp/wobpipe")
end

local sink_number = 1

M = {}
M.raise = function(amount) adjust(sink_number, amount) end
M.lower = function(amount) adjust(sink_number, -1 * amount) end
return M
