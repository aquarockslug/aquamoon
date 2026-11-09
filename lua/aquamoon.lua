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

local function greeter_user()
	local user = os.getenv("GREETER_USER")
	if user ~= nil and user ~= "" then
		return user
	end
	local handle = io.popen(
		"noctalia-greeter-apply-appearance --print-greeter-user 2>/dev/null")
	if handle then
		local value = handle:read("*l")
		handle:close()
		if value ~= nil and value ~= "" then
			return value
		end
	end
	return "greeter"
end

-- The greeter runs as the greetd session user, which cannot read ~/.aquamoon
-- (the home directory is private).  Install the declarative config and the
-- wallpaper into its state directory instead of symlinking the repository.
local function install_greeter()
	local user = greeter_user()
	local dir = "/var/lib/noctalia-greeter"
	local config = repo .. "/toml/noctalia-greeter.toml"
	local wallpaper = repo .. "/wallpapers/macos_tiger_grey.png"
	local files = {
		dir .. "/greeter.toml",
		dir .. "/wallpaper.png",
	}
	local commands = {
		"install -d -m750 -o " .. quote(user) .. " -g " .. quote(user)
			.. " " .. quote(dir),
		"install -Dm644 " .. quote(config) .. " " .. quote(files[1]),
		"install -Dm644 " .. quote(wallpaper) .. " " .. quote(files[2]),
		"chown " .. quote(user .. ":" .. user) .. " " .. quote(dir)
			.. " " .. quote(files[1]) .. " " .. quote(files[2]),
	}
	local command = table.concat(commands, " && ")
	local ok = run("sudo sh -c " .. quote(command))
	if ok ~= true and ok ~= 0 then
		print("could not install the greeter configuration; run:")
		print("  sudo sh -c " .. quote(command))
		return false
	end
	return true
end

local function setup()
	local missing = {}
	for _, dep in ipairs({ "lua5.4", "luarocks", "river", "tofi", "noctalia",
		"noctalia-greeter", "greetd", "neovide" }) do
		local ok = os.execute("command -v " .. dep .. " >/dev/null 2>&1")
		if ok ~= true and ok ~= 0 then
			missing[#missing + 1] = dep
		end
	end
	if #missing > 0 then
		print("missing: " .. table.concat(missing, " "))
	end

	-- Generate the wau protocol bindings in the vendored source tree.  The
	-- session runs wm straight from the repository, so no install step is
	-- needed and edits to wm/wm.lua are picked up on restart.
	local wm_dir = repo .. "/wm"
	local ok = run("cd " .. quote(wm_dir)
		.. " && eval $(luarocks --lua-version=5.4 path)"
		.. " && set -e"
		.. " && for f in protocol/*.xml; do"
		.. " wau-scanner < \"$f\" > \"${f%%.xml}.lua\"; done")
	if ok ~= true and ok ~= 0 then
		print("failed to generate wm protocol bindings")
		return
	end
	run("chmod +x " .. quote(repo .. "/bin/wm"))

	local config_dir = os.getenv("XDG_CONFIG_HOME")
	if not config_dir or config_dir == "" then
		config_dir = home .. "/.config"
	end
	run("mkdir -p " .. quote(config_dir .. "/river") .. " "
		.. quote(config_dir .. "/noctalia"))

	local init = assert(io.open(config_dir .. "/river/init", "w"))
	init:write("#!/bin/sh\nexec " .. quote(repo .. "/bin/wm") .. "\n")
	init:close()
	run("chmod +x " .. quote(config_dir .. "/river/init"))
	-- When the repository itself is symlinked as the Noctalia config
	-- directory, its config.toml includes toml/noctalia.toml already and no
	-- extra link is needed.
	if readlink(config_dir .. "/noctalia") ~= repo then
		link(repo .. "/toml/noctalia.toml", config_dir .. "/noctalia/config.toml")
	end

	local greeter = os.execute(
		"command -v noctalia-greeter >/dev/null 2>&1")
	if greeter == true or greeter == 0 then
		if install_greeter() then
			print("greeter configured; restart greetd to apply: "
				.. "sudo systemctl restart greetd")
		end
	else
		print("skip greeter configuration: noctalia-greeter is not installed")
	end

	if readlink(config_dir .. "/nvim") ~= repo then
		print("link Neovim config: ln -s " .. quote(repo) .. " " .. quote(config_dir .. "/nvim"))
	end
	print("configured; start the session with: river")
end

local mode = arg and arg[1]
if mode == "setup" then
	setup()
end
