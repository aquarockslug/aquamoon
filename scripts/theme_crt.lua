local tinytoml = dofile(os.getenv("HOME") .. "/.aquamoon/scripts/sys_tinytoml.lua")
local script_path = os.getenv("HOME") .. "/.local/bin/crt.js"

local function start()
    local f = io.open(script_path, "r")
    if not f then
        io.stderr:write("Error: shader not found at " .. script_path .. "\n")
        return false
    end
    f:close()
    os.execute("gjs " .. script_path .. " &")
    print("CRT overlay started")
    return true
end

local function stop()
    os.execute("pkill -f crt.js 2>/dev/null")
    print("CRT overlay stopped")
    return true
end

local function status()
    local h = io.popen("pgrep -f crt.js")
    local r = h:read("*a")
    h:close()
    print(r and #r > 0 and "CRT overlay is running" or "CRT overlay is not running")
end

local cmds = { start = start, stop = stop, status = status }

if arg and arg[1] then
    local cmd = cmds[arg[1]]
    if cmd then
        cmd()
    else
        print("Usage: lua crt.lua <start|stop|status>")
    end
end

return { start = start, stop = stop, status = status, load_config = load_config }
