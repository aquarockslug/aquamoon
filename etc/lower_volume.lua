local amount = 5
os.execute("pamixer --decrease " .. amount)
os.execute("echo $(pamixer --get-volume) > /tmp/wobpipe")
