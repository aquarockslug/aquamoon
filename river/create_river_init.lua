#!/usr/bin/env lua

local username = "aqua"
local userdir = "/home/" .. username
local aquamoondir = userdir .. "/.aquamoon"

local init_lua = aquamoondir .. "/river/init.lua"

local f = io.open(init_lua, "r")
if f then
	f:close()
	local script_path = userdir .. "/.config/river/init"
	local script = "#!/bin/bash\nlua " .. init_lua .. "\n"
	local sf = io.open(script_path, "w")
	if sf then
		sf:write(script)
		sf:close()
		os.execute("chmod +x " .. script_path)
		print("Created river init bash script at " .. script_path)
	else
		io.stderr:write("Error: Could not create script at " .. script_path .. "\n")
		os.exit(1)
	end
else
    io.stderr:write("Error: " .. init_lua .. " not found\n")
    os.exit(1)
end
