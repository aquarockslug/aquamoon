-- Search path for the luarocks modules used by the aquamoon2 configuration.
--
-- The rocks are installed in the lua_modules/ directory of the repository
-- (see the README), which is not part of the default Lua search path. Load
-- this module before requiring them:
--
--   require("scripts/util/paths")
--
-- The paths are absolute, so the scripts work from any directory.

local source = debug.getinfo(1, "S").source:sub(2) -- strip the leading "@"
local scripts_dir = source:match("^(.*)[/\\][^/\\]*$") or "."
local repo = scripts_dir .. "/../.."

local version = _VERSION:match("%d+%.%d+")
local share = repo .. "/lua_modules/share/lua"

-- The rocks of the running Lua version.
local entries = {
	share .. "/" .. version .. "/?.lua",
	share .. "/" .. version .. "/?/init.lua",
}

-- The pure Lua rocks of the other Lua versions: neovim runs LuaJIT (5.1)
-- while the scripts run the system Lua (5.5), and a pure Lua module works
-- with both, so every version directory of the tree is searched.
local function version_dirs()
	local dirs = {}
	if vim and vim.fn then
		for _, dir in ipairs(vim.fn.glob(share .. "/*/", false, true)) do
			dirs[#dirs + 1] = dir:gsub("/$", "")
		end
	else
		local handle = io.popen("ls -d " .. share .. "/*/ 2>/dev/null")
		if handle then
			for dir in handle:lines() do
				dirs[#dirs + 1] = dir:gsub("/$", "")
			end
			handle:close()
		end
	end
	return dirs
end

for _, dir in ipairs(version_dirs()) do
	if dir ~= share .. "/" .. version then
		entries[#entries + 1] = dir .. "/?.lua"
		entries[#entries + 1] = dir .. "/?/init.lua"
	end
end

package.path = table.concat(entries, ";") .. ";" .. package.path
package.cpath = repo .. "/lua_modules/lib/lua/" .. version .. "/?.so;"
	.. package.cpath

return { repo = repo }
