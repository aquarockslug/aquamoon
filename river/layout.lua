-- You can define your global state here
local main_ratio = 0.66
local gaps = 8
local smart_gaps = false
local offset = 0

local current_tag = 1

--  * Focused tags (`args.tags`)
--  * Window count (`args.count`)
--  * Output width (`args.width`)
--  * Output height (`args.height`)
--  * Output name (`args.output`)
function handle_layout(args)
	local retval = {}
	if args.count == 1 then
		if smart_gaps then
			table.insert(retval, { 0, 0, args.width, args.height })
		else
			table.insert(retval, { gaps, gaps, args.width - gaps * 2, args.height - gaps * 2 })
		end
	elseif args.count > 1 then
		local main_w = (args.width - gaps * 3) * main_ratio
		local side_w = (args.width - gaps * 3) - main_w
		local main_h = args.height - gaps * 2
		local side_h = (args.height - gaps) / (args.count - 1) - gaps
		table.insert(retval, {
			offset + gaps,
			gaps,
			main_w,
			main_h,
		})
		for i = 0, (args.count - 2) do
			table.insert(retval, {
				offset + main_w + gaps * 2,
				gaps + i * (side_h + gaps),
				side_w,
				side_h,
			})
		end
	end
	-- use a variable to check if the current tag has changed
	local t = args.tags
	if current_tag ~= t then
		current_tag = t

		local flag_string = ""
		-- add to flag string every time we divide by two until it is 1
		while t >= 1.0 do
			t = t / 2
			flag_string = flag_string .. " 󰈿"
		end
		-- show numbers if there are more than 4 flags
		if string.len(flag_string) > 20 then
			flag_string = tostring(string.len(flag_string) / 5) .. " " .. flag_string
		end

		-- get the color info from the theme file
		os.execute("dunstify --timeout=1000 --appname=luatile " ..
			"-h string:bgcolor:#2a2a3a " ..
			"-h string:fgcolor:#92d3c5 " ..
			"-h string:frcolor:#92d3c5 " ..
			"--replace=9 '" .. flag_string .. "'")
	end
	return retval
end

-- TODO layout keybind to change main_ratio

function handle_metadata(args)
	return { name = " 󰈿 " }
end

function scroll() -- TODO scrolling window manager?
	offset = offset - 10
end

local gaps_alt = 16
function toggle_gaps()
	local tmp = gaps
	gaps = gaps_alt
	gaps_alt = tmp
end
