#!/usr/bin/lua5.4

local amount = 100
if args then amount = args[1] end

for i = 1, amount do
	print(lush.getHistory(i))
end
