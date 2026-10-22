-- Screenshot tool for Aquamoon
-- Captures selected screen region, copies to clipboard, and opens in image viewer

local file_name = "screenshot" .. os.date("_at_%I_%M%p")
local dir = os.getenv("HOME") .. "/Pictures/Screenshots"
os.execute("mkdir -p " .. dir)
local path = dir .. "/" .. file_name .. ".jpg"

local selection = io.popen("slurp")
os.execute("grim -g '" .. selection:read("*a"):match("^%s*(.-)%s*$") .. "' " .. path)
selection:close()

os.execute("cat " .. path .. " | wl-copy")

os.execute("riverctl spawn 'loupe " .. path .. "'")

os.execute("dunstify --timeout 1000 '󰈿 Screenshot Taken'")
