-- take a screenshot and open it with loupe image viewer

local file_name = "screenshot_" .. os.date("_at_%I_%M%p")
local path = "~/Pictures/Screenshots/" .. file_name .. ".jpg"

-- Take the screenshot and save it to "path"
os.execute("grim -t jpeg " .. path)

-- Copy the image to the system clipboard
os.execute("cat " .. path .. " | wl-copy")

-- Open the image for cropping
os.execute("riverctl spawn 'loupe " .. path .. "'")

-- Notify
-- TODO add an action to the notification that opens loupe or gimp
os.execute("dunstify '󰈿 Screenshot Taken'")
