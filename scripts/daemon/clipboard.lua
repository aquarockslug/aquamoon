-- Clipboard history daemon
-- Watches clipboard for changes and saves to history file

local home = os.getenv("HOME")
local history_path = home .. "/.aquamoon/clipboard_history"
local max_entries = 100

local function read_history()
    local entries = {}
    local file = io.open(history_path, "r")
    if file then
        for line in file:lines() do
            table.insert(entries, line)
        end
        file:close()
    end
    return entries
end

local function write_history(entries)
    local file = io.open(history_path, "w")
    if file then
        for _, entry in ipairs(entries) do
            file:write(entry .. "\n")
        end
        file:close()
    end
end

local function add_entry(content)
    local entries = read_history()

    for i, entry in ipairs(entries) do
        if entry == content then
            table.remove(entries, i)
            break
        end
    end

    table.insert(entries, 1, content)

    while #entries > max_entries do
        table.remove(entries)
    end

    write_history(entries)
end

local handle = io.popen("wl-paste -w cat")
if not handle then
    print("Failed to start wl-paste watcher")
    return
end

while true do
    local line = handle:read("*l")
    if line and #line > 0 then
        add_entry(line)
    end
end