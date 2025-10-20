local percent_change = 5
os.execute("brightnessctl set " .. percent_change .. "%-")
-- TODO divide 'brightnessctl max' by 'brightnessctl get' before sending it to wobpipe
-- os.execute("echo $(brightnessctl get) > /tmp/wobpipe")
-- os.execute("tail -f /tmp/wobpipe | wob") '
