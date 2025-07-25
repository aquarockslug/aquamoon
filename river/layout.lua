-- You can define your global state here
local main_ratio = 0.65
local gaps = 2
local smart_gaps = false

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
			gaps,
			gaps,
			main_w,
			main_h,
		})
		for i = 0, (args.count - 2) do
			table.insert(retval, {
				main_w + gaps * 2,
				gaps + i * (side_h + gaps),
				side_w,
				side_h,
			})
		end
	end
	return retval
end

function handle_metadata(args)
	return { name = "rivertile" }
end

local gaps_alt = 0
function toggle_gaps()
	local tmp = gaps
	gaps = gaps_alt
	gaps_alt = tmp
end

-- TODO set LUA_PATH
-- package.path = '/home/aqua/.aquamoon/?/?.lua;/home/aqua/.aquamoon/?.lua;;'
-- require('etc/launcher')
-- nvim -es?
local lua_path = 'export LUA_PATH="/home/aqua/.aquamoon/?/?.lua;/home/aqua/.aquamoon/?.lua;;";'

function Launcher()
	os.execute(lua_path .. ' lua /home/aqua/.aquamoon/etc/tofi.lua')
end

function Network_Menu()
	os.execute(lua_path .. ' lua /home/aqua/.aquamoon/etc/nm_tofi.lua')
end

function Web_Search()
	os.execute(lua_path .. ' lua /home/aqua/.aquamoon/etc/ddgr.lua')
end

-- WARN the terminal window is not being added to the layout
function Terminal()
	os.execute(lua_path .. ' lua /home/aqua/.aquamoon/etc/foot.lua')
end

function System_Menu()
	os.execute(lua_path .. ' lua /home/aqua/.aquamoon/etc/system_menu.lua')
end
