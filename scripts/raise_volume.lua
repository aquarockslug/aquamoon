local amount = 5
os.execute("pamixer --increase " .. amount)

local curr_volume = io.popen("pamixer --get-volume")

local S = dofile(os.getenv("HOME") .. "/.aquamoon/settings.lua")
dofile(S.path .. "/scripts/notify.lua").bar(curr_volume:read("*a"), "Volume")
curr_volume:close()
