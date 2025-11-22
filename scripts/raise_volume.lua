local amount = 5
os.execute("pamixer --increase " .. amount)

local curr_volume = io.popen("pamixer --get-volume")

require("lib.paths").setup_paths()
require "scripts/notify".bar(curr_volume:read("*a"), "Volume")
curr_volume:close()
