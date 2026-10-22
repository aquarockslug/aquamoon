-- Setup helper for the aquamoon2-river branch
--
-- Creates the two things river needs to pick up this repository:
--   ~/.config/river/init          -> bash wrapper that runs lua/river/init.lua
--   ~/.config/river-luatile       -> symlink to lua/river (river-luatile
--                                    reads <dir>/layout.lua from there)
--
-- It also reports missing dependencies: the system commands and the Lua
-- modules of lua_modules/ (the README explains how to install the rocks).

local home = os.getenv("HOME")
local repo = home .. "/.aquamoon"

local DEPS = {
	"river", "river-luatile", "riverctl", "tofi", "dunst", "neovide", "lswt",
	"pamixer", "brightnessctl", "grim", "slurp", "wl-copy",
}

local function has(cmd)
	local ok = os.execute("command -v " .. cmd .. " >/dev/null 2>&1")
	return ok == 0 or ok == true
end

print("== Dependencies ==")
local missing = {}
for _, dep in ipairs(DEPS) do
	if has(dep) then
		print("  " .. dep .. ": ok")
	else
		table.insert(missing, dep)
		print("  " .. dep .. ": MISSING")
	end
end
if #missing > 0 then
	print("  install with: sudo pacman -S " .. table.concat(missing, " "))
end

-- The Lua modules are luarocks rocks, installed in lua_modules/ (see README).
local function has_module(name)
	local handle = io.popen(
		"find " .. repo .. "/lua_modules/share " .. repo .. "/lua_modules/lib "
			.. "-name '" .. name .. ".lua' -o -name '" .. name .. ".so' 2>/dev/null"
	)
	if not handle then
		return false
	end
	local found = handle:read("*l") ~= nil
	handle:close()
	return found
end

print("== Lua modules ==")
local ROCKS = {
	{ module = "tinytoml", rock = "tinytoml" },
	{ module = "lfs", rock = "luafilesystem" },
	{ module = "tofi", rock = "tofi-lua" },
}
local missing_rocks = {}
for _, r in ipairs(ROCKS) do
	if has_module(r.module) then
		print("  " .. r.rock .. ": ok")
	else
		table.insert(missing_rocks, r.rock)
		print("  " .. r.rock .. ": MISSING")
	end
end
if #missing_rocks > 0 then
	print("  install with: luarocks --tree " .. repo .. "/lua_modules install "
		.. table.concat(missing_rocks, " "))
end

print("== River init ==")
local init_path = home .. "/.config/river/init"
os.execute("mkdir -p " .. home .. "/.config/river")
local f = io.open(init_path, "w")
if f then
	f:write("#!/bin/bash\nlua " .. repo .. "/lua/river/init.lua\n")
	f:close()
	os.execute("chmod +x " .. init_path)
	print("  wrote " .. init_path)
end

print("== River luatile layout ==")
local luatile_path = home .. "/.config/river-luatile"
local current = os.getenv("XDG_CONFIG_HOME")
if not current or current == "" then current = home .. "/.config" end
local link = current .. "/river-luatile"
local existing = io.open(link .. "/layout.lua", "r")
if existing then
	existing:close()
	print("  " .. link .. "/layout.lua already present")
else
	os.execute("mkdir -p " .. current)
	os.execute("rm -rf " .. link)
	os.execute("ln -s " .. repo .. "/lua/river " .. link)
	print("  linked " .. link .. " -> " .. repo .. "/lua/river")
end

print("== Neovim config ==")
local nvim_path = home .. "/.config/nvim"
local handle = io.popen("readlink -f " .. nvim_path .. " 2>/dev/null")
local target = handle and handle:read("*a") or ""
if handle then handle:close() end
target = target:gsub("%s+$", "")
if target == repo then
	print("  " .. nvim_path .. " -> " .. target .. " (ok)")
else
	print("  " .. nvim_path .. " does not point at " .. repo)
	print("  ln -s " .. repo .. " " .. nvim_path)
end

print()
print("Done. Start the session with: river")
print("The neovim configuration is the aquamoon2 one; start it with:")
print("  NVIM_APPNAME=nvim neovide")
