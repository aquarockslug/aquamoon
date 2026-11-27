#!/usr/bin/env lua
local dmenu = require("noctalia-dmenu")

-- serein is Discord, aurora is Steam, streamtube is YouTube, flectar-mail is Email
local choice = dmenu({ "serein", "aurora", "streamtube", "flectar-mail" }, { prompt = "Favorite Apps" })

if choice then os.execute(choice) end
