package.path = package.path .. ";" .. os.getenv("HOME") .. "/.aquamoon/?.lua"
local notify = require("scripts/sys/notify")

local main_ratio = 2 / 3
local gaps = 0
local smart_gaps = true
local offset = 0
local gaps_alt = 8

-- The argument is a table with:
--  * Focused tags (`args.tags`)
--  * Window count (`args.count`)
--  * Output width (`args.width`)
--  * Output height (`args.height`)
--  * Output name (`args.output`)
--
-- The return value must be a table with exactly `count` entries. Each entry is a table with four
-- numbers:
--  * X coordinate
--  * Y coordinate
--  * Window width
--  * Window height

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

	notify.tally(args.tags)

	return retval
end

function handle_metadata()
	return { name = "river_luatile" }
end

function modify_main_ratio(amount)
	main_ratio = math.max(0.1, math.min(0.9, main_ratio + amount * 0.01))
end

function set_main_ratio(n)
	main_ratio = math.max(0.1, math.min(0.9, tonumber(n) or 0.5))
end

function set_gaps(n)
	gaps = tonumber(n) or 0
	smart_gaps = false
end

function toggle_smart_gaps()
	smart_gaps = not smart_gaps
end

function set_offset(n)
	offset = tonumber(n) or 0
end

function toggle_gaps()
	local tmp = gaps
	gaps = gaps_alt
	gaps_alt = tmp
end

function reset_layout()
	main_ratio = 2 / 3
	gaps = 0
	smart_gaps = true
	offset = 0
	gaps_alt = 8
end
