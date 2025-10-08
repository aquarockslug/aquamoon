local path = "~/Pictures/screenshot.jpg"

-- Take the screenshot and save it to "path"
os.execute("grim -t jpeg " .. path)

-- Quickly open gimp for cropping the image
os.execute("gimp --no-splash --no-data " .. path .. " &")

-- Notify
os.execute("notify-send '󰈿 Screenshot Taken'")
