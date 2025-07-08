local M = {}

local utils = require("layouts.utils")

M.handle_layout = function(args)
	local retval = {}

	--
	local height_for_n = function(n)
		return utils.height_for_n(args, n)
	end
	--

	if args.count == 1 then
		if SMART_GAPS then
			table.insert(retval, { 0, 0, args.width, args.height })
		else
			table.insert(retval, { OUTER_GAPS, OUTER_GAPS, args.width - OUTER_GAPS * 2, args.height - OUTER_GAPS * 2 })
		end
	elseif args.count > 1 then
		local main_w = (args.width - 2 * OUTER_GAPS - INNER_GAPS) * MAIN_RATIO
		local side_w = (args.width - 2 * OUTER_GAPS - INNER_GAPS) - main_w
		local main_h = args.height - OUTER_GAPS * 2
		local side_h = height_for_n(args.count - 1)
		table.insert(retval, {
			OUTER_GAPS,
			OUTER_GAPS,
			main_w,
			main_h,
		})
		for i = 0, (args.count - 2) do
			table.insert(retval, {
				main_w + OUTER_GAPS + INNER_GAPS,
				OUTER_GAPS + i * (side_h + INNER_GAPS),
				side_w,
				side_h,
			})
		end
	end
	return retval
end

return M
