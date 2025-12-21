local wait_time = arg[1]
local message = arg[2]

os.execute("sleep " .. wait_time)
os.execute("dunstify " .. message)
