#!/usr/bin/env lua

-- Timer utility for Aquamoon
-- Waits specified duration then sends notification with custom message

local M = {}

local S = dofile(os.getenv("HOME") .. "/.aquamoon/settings.lua")

local wait_time = arg[1]
local message = arg[2]

if not wait_time then
    io.write("Enter time (in seconds): ")
    wait_time = io.read()
end

if not message then
    io.write("Enter message: ")
    message = io.read()
end

os.execute("sleep " .. wait_time)
dofile(S.path .. "/scripts/trigger/notify.lua").send(message)

return M