local home = os.getenv("HOME")
local repo = home .. "/.aquamoon"

local function quote(value)
	return "'" .. tostring(value):gsub("'", "'\\''") .. "'"
end

local function run(command)
	return os.execute(command)
end

local function readlink(path)
	local handle = io.popen("readlink -f " .. quote(path) .. " 2>/dev/null")
	local target = handle and handle:read("*l") or ""
	if handle then
		handle:close()
	end
	return target
end

local function link(target, path)
	if readlink(path) == target then
		return
	end
	local existing = io.open(path, "r")
	if existing then
		existing:close()
		print("exists: " .. path .. " (expected " .. target .. ")")
		return
	end
	run("ln -s " .. quote(target) .. " " .. quote(path))
end

local function setup()
	local missing = {}
	for _, dep in ipairs({ "lua5.4", "luarocks", "river", "tofi", "noctalia", "neovide" }) do
		local ok = os.execute("command -v " .. dep .. " >/dev/null 2>&1")
		if ok ~= true and ok ~= 0 then
			missing[#missing + 1] = dep
		end
	end
	if #missing > 0 then
		print("missing: " .. table.concat(missing, " "))
	end

	local tinyrwm = repo .. "/tinyrwm"
	local ok = run("cd " .. quote(tinyrwm)
		.. " && eval $(luarocks --lua-version=5.4 path)"
		.. " && luarocks --lua-version=5.4 --local make")
	if ok ~= true and ok ~= 0 then
		print("failed to build tinyrwm")
		return
	end

	local config_dir = os.getenv("XDG_CONFIG_HOME")
	if not config_dir or config_dir == "" then
		config_dir = home .. "/.config"
	end
	run("mkdir -p " .. quote(config_dir .. "/river") .. " "
		.. quote(config_dir .. "/noctalia"))

	local init = assert(io.open(config_dir .. "/river/init", "w"))
	init:write("#!/bin/sh\nexec \"$HOME/.luarocks/bin/tinyrwm\"\n")
	init:close()
	run("chmod +x " .. quote(config_dir .. "/river/init"))
	link(repo .. "/toml/noctalia.toml", config_dir .. "/noctalia/config.toml")

	if readlink(config_dir .. "/nvim") ~= repo then
		print("link Neovim config: ln -s " .. quote(repo) .. " " .. quote(config_dir .. "/nvim"))
	end
	print("configured; start the session with: river")
end

local mode = arg and arg[1]
if mode == "setup" then
	setup()
end
