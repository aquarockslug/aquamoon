-- Color picker tool for Aquamoon
-- Copies the hex code of the color under the cursor

local handle = io.popen(
  "grim -g \"$(slurp -b '#00000000' -p)\" -t ppm - | "
  .. "magick - -format '%[pixel:p{0,0}]' txt:- | "
  .. "awk 'END{print $3}'"
)
local color = handle:read("*l")
handle:close()

package.path = package.path .. ";" .. os.getenv("HOME") .. "/.aquamoon/?.lua"
local notify = require("scripts/sys/notify")

if not color or color == "" then
  notify.send("No color selected.")
  os.exit(1)
end

local clip = io.popen("wl-copy", "w")
clip:write(color)
clip:close()

notify.send("Color: " .. color)
