local amount = 5
os.execute("pamixer --increase " .. amount)
os.execute("echo $(pamixer --get-volume) > /tmp/wobpipe")
os.execute("tail -f /tmp/wobpipe | wob")
