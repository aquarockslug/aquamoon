package.path = '/home/aqua/.aquamoon/?.lua;/home/aqua/.aquamoon/?/?.lua;' ..
    '/home/aqua/.aquamoon/rocks/share/lua/5.1/?.lua;' ..
    '/home/aqua/.aquamoon/rocks/share/lua/5.1/?/?.lua;;'

local main_ratio = 2 / 3
local gaps = 0 -- 6 TODO make this an aquamoon theme settings
local smart_gaps = true
local offset = 0

local last_view_count = 0

--  * Focused tags (`args.tags`)
--  * Window count (`args.count`)
--  * Output width (`args.width`)
--  * Output height (`args.height`)
--  * Output name (`args.output`)
function handle_layout(args)
	last_view_count = args.count
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

	-- only use layout notifications on the laptop screen "eDP-1"
	if args.output ~= "eDP-1" then return retval end

	require("scripts/notify").tally(args.tags)

	return retval
end

function handle_metadata()
	return { name = "river_rotate" }
end

-- keep focus on the top of the stack while shifting views
function rotate(clockwise)
	if (clockwise) then
		-- rotate clockwise: last to first
		os.execute "riverctl focus-view previous && riverctl zoom"
	else
		-- rotate counter-clockwise: move first to last
		for i = 1, last_view_count - 1 do
			os.execute "riverctl swap next"
		end
		for i = 1, last_view_count - 1 do
			os.execute "riverctl focus-view previous"
		end
	end
end

function modify_main_ratio(amount)
	main_ratio = main_ratio + amount * 0.01
end
