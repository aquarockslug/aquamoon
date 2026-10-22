-- Setup helper for the aquamoon2-river branch
--
-- Creates the two things river needs to pick up this repository:
--   ~/.config/river/init          -> bash wrapper that runs scripts/river/init.lua
--   ~/.config/river-luatile       -> symlink to scripts/river (river-luatile
--                                    reads <dir>/layout.lua from there)
--
-- It also reports missing dependencies.

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

print("== River init ==")
local init_path = home .. "/.config/river/init"
os.execute("mkdir -p " .. home .. "/.config/river")
local f = io.open(init_path, "w")
if f then
	f:write("#!/bin/bash\nlua " .. repo .. "/scripts/river/init.lua\n")
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
	os.execute("ln -s " .. repo .. "/scripts/river " .. link)
	print("  linked " .. link .. " -> " .. repo .. "/scripts/river")
end

print()
print("Done. Start the session with: river")
print("The neovim configuration is the aquamoon2 one; start it with:")
print("  NVIM_APPNAME=nvim neovide")
