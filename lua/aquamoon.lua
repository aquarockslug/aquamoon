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

local function exists(path)
	local ok = os.execute("test -e " .. quote(path) .. " -o -L " .. quote(path))
	return ok == true or ok == 0
end

local function link(target, path)
	local resolved_target = readlink(target)
	if resolved_target ~= "" and readlink(path) == resolved_target then
		return
	end
	if exists(path) then
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

local default_tv_theme = table.concat({
	"# Noctalia theme for Television (Rose Pine Moon fallback).",
	'border_fg = "#44415a"',
	'text_fg = "#e0def4"',
	'dimmed_text_fg = "#908caa"',
	'input_text_fg = "#ea9a97"',
	'result_count_fg = "#9ccfd8"',
	'result_name_fg = "#ea9a97"',
	'result_line_number_fg = "#32758f"',
	'result_value_fg = "#e0def4"',
	'selection_fg = "#ea9a97"',
	'selection_bg = "#393552"',
	'match_fg = "#9ccfd8"',
	'preview_title_fg = "#9ccfd8"',
	'channel_mode_fg = "#232136"',
	'channel_mode_bg = "#ea9a97"',
	'remote_control_mode_fg = "#232136"',
	'remote_control_mode_bg = "#9ccfd8"',
	'action_picker_mode_fg = "#d0cdee"',
	'action_picker_mode_bg = "#32758f"',
	"",
}, "\n")

local function setup()
	local missing = {}
	for _, dep in ipairs({ "lua5.4", "luarocks", "river", "tofi", "noctalia",
		"noctalia-greeter", "greetd", "neovide", "tv" }) do
		local ok = os.execute("command -v " .. dep .. " >/dev/null 2>&1")
		if ok ~= true and ok ~= 0 then
			missing[#missing + 1] = dep
		end
	end
	if not exists("/usr/lib/upowerd") then
		missing[#missing + 1] = "upower"
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
	run("chmod +x " .. quote(repo .. "/bin/wm") .. " " .. quote(repo .. "/bin/haal"))

	local config_dir = os.getenv("XDG_CONFIG_HOME")
	if not config_dir or config_dir == "" then
		config_dir = home .. "/.config"
	end
	run("mkdir -p " .. quote(config_dir .. "/river") .. " "
		.. quote(config_dir .. "/haal") .. " "
		.. quote(config_dir .. "/television/cable") .. " "
		.. quote(config_dir .. "/television/themes"))

	local init = assert(io.open(config_dir .. "/river/init", "w"))
	init:write("#!/bin/sh\nexec " .. quote(repo .. "/bin/wm") .. "\n")
	init:close()
	run("chmod +x " .. quote(config_dir .. "/river/init"))

	local state_dir = os.getenv("XDG_STATE_HOME")
	if not state_dir or state_dir == "" then
		state_dir = home .. "/.local/state"
	end
	run("mkdir -p " .. quote(state_dir .. "/noctalia"))
	local storage_key = state_dir .. "/noctalia/storage.key"
	if not exists(storage_key) then
		run("umask 077 && od -An -N32 -tx1 /dev/urandom | tr -d ' \\n' > "
			.. quote(storage_key) .. " && echo >> " .. quote(storage_key))
	end

	-- When the repository itself is symlinked as the Noctalia config
	-- directory, its config.toml includes toml/noctalia.toml and exposes
	-- palettes/ directly. Otherwise, link config.toml and palettes/ inside
	-- ~/.config/noctalia.
	if readlink(config_dir .. "/noctalia") ~= readlink(repo) then
		run("mkdir -p " .. quote(config_dir .. "/noctalia"))
		link(repo .. "/toml/noctalia.toml", config_dir .. "/noctalia/config.toml")
		link(repo .. "/palettes", config_dir .. "/noctalia/palettes")
	end

	link(repo, config_dir .. "/nvim")
	link(repo .. "/toml/starship.toml", config_dir .. "/starship.toml")
	link(repo .. "/lua/haal-fetch.lua", config_dir .. "/haal/init.lua")

	run("ln -sf " .. quote(repo .. "/toml/television.toml") .. " "
		.. quote(config_dir .. "/television/config.toml"))
	run("for f in " .. quote(repo .. "/cable") .. "/*.toml; do "
		.. "[ -e \"$f\" ] && ln -sf \"$f\" "
		.. quote(config_dir .. "/television/cable") .. "/; done")
	local tv_theme_path = config_dir .. "/television/themes/noctalia.toml"
	if not exists(tv_theme_path) then
		local tv_theme = assert(io.open(tv_theme_path, "w"))
		tv_theme:write(default_tv_theme)
		tv_theme:close()
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

	print("configured; start the session with: river")
end

local mode = arg and arg[1]
if mode == "setup" then
	setup()
end
