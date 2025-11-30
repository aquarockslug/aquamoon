-- This file sets up the package.path so lua can find aquamoon and luarocks
-- Adds paths only if they are not already present
-- this file should be linked or moved to /usr/share/lua/lib

local function get_aquamoon_path()
    -- return os.getenv("HOME") .. "/.aquamoon"
    return "/home/aqua/.aquamoon"
end

local function setup_paths()
    local aquamoon_path = get_aquamoon_path()
    local aquamoon_lua_path = aquamoon_path .. "/?.lua;" .. aquamoon_path .. "/?/?.lua"

    -- Add aquamoon path if not already present
    if not package.path:find(aquamoon_lua_path, 1, true) then
        package.path = package.path .. aquamoon_lua_path .. ";"
    end
end

local function setup_rocks_paths()
    local aquamoon_path = get_aquamoon_path()
    local rocks_path = aquamoon_path .. "/rocks/share/lua/5.1/?.lua;" ..
                      aquamoon_path .. "/rocks/share/lua/5.1/?/init.lua"

    if not package.path:find(rocks_path, 1, true) then
        package.path = package.path .. rocks_path .. ";"
    end
end

local function setup_nvim_rocks_paths()
    local rocks_path = "/home/aqua/.local/share/nvim/rocks/share/lua/5.1/?.lua;" ..
                      "/home/aqua/.local/share/nvim/rocks/share/lua/5.1/?/init.lua;"
    local rocks_cpath = "/home/aqua/.local/share/nvim/rocks/lib/lua/5.1/?.so;" ..
                       "/home/aqua/.local/share/nvim/rocks/lib64/lua/5.1/?.so;"

    -- Add rocks path if not already present
    if not package.path:find(rocks_path, 1, true) then
        package.path = package.path .. rocks_path
    end

    if not package.cpath:find(rocks_cpath, 1, true) then
        package.cpath = package.cpath .. rocks_cpath .. ";"
    end
end

return {
    get_aquamoon_path = get_aquamoon_path,
    setup_paths = setup_paths,
    setup_rocks_paths = setup_rocks_paths,
    setup_nvim_rocks_paths = setup_nvim_rocks_paths
}
