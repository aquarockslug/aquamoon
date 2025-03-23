#!/usr/bin/lua5.4
-- pick from the last 1000 entries in shell history

local entries = {}
for i = 1, 1000 do entries[i] = lush.getHistory(i) end
io.write(require("aquamoon/scripts/pick").with_tofi(entries))
