#!/usr/bin/env lush

local function has_cmd(cmd)
	local ok = os.execute("command -v " .. cmd .. " >/dev/null 2>&1")
	return ok == true or ok == 0
end

local function is_running(proc_name)
	for _, name in ipairs(os.proc_names() or {}) do
		if name == proc_name then
			return true
		end
	end
	return false
end

local function start_syncthing()
	if not has_cmd("syncthing") then
		print("Syncthing is not installed. Installing...")
		local ok = os.execute("sudo pacman -S --needed --noconfirm syncthing")
		if ok ~= true and ok ~= 0 then
			error("Failed to install syncthing")
		end
	end

	if is_running("syncthing") then
		print("Syncthing is already running")
		return
	end

	print("Starting Syncthing...")
	local ok = os.execute("syncthing --no-browser >/dev/null 2>&1 &")
	if ok ~= true and ok ~= 0 then
		error("Failed to start syncthing")
	end
end

start_syncthing()
