-- take a screenshot and open it with loupe image viewer

local file_name = "screenshot" .. os.date("_at_%I_%M%p")
local path = "~/Pictures/Screenshots/" .. file_name .. ".jpg"

-- Take the screenshot and save it to "path"
local selection = io.popen("slurp")
os.execute("grim -g '" .. selection:read("*a"):match("^%s*(.-)%s*$") .. "' " .. path)
selection:close()

-- Copy the image to the system clipboard
os.execute("cat " .. path .. " | wl-copy")

-- Open the image for cropping
os.execute("riverctl spawn 'loupe " .. path .. "'")

-- Notify
-- TODO add an action to the notification that opens loupe or gimp
os.execute("dunstify --timeout 1000 '󰈿 Screenshot Taken'")
