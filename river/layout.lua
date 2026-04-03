-- River layout handler for Aquamoon
-- Implements custom window tiling layout and tag notifications

local main_ratio = 2 / 3
local gaps = 0
local smart_gaps = true
local offset = 0
local last_view_count = 0

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

	if args.output ~= "eDP-1" then return retval end

	dofile(os.getenv("HOME") .. "/.aquamoon/scripts/util_notify.lua").tally(args.tags)

	return retval
end

function handle_metadata()
	return { name = "river_rotate" }
end

function modify_main_ratio(amount)
	main_ratio = main_ratio + amount * 0.01
end

