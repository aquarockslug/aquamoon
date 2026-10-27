local home = os.getenv("HOME")
local repo = home .. "/.aquamoon"
package.path = repo .. "/lua/?.lua;" .. package.path

local config_cache

local function config()
	config_cache = config_cache or require("tinytoml").parse(repo .. "/toml/aquamoon.toml")
	return config_cache
end

local function quote(value)
	return "'" .. tostring(value):gsub("'", "'\\''") .. "'"
end

local function run(command)
	os.execute(command)
end

local function readlink(path)
	local handle = io.popen("readlink -f " .. quote(path) .. " 2>/dev/null")
	local target = handle and handle:read("*l") or ""
	if handle then
		handle:close()
	end
	return target
end

local function value(input)
	return type(input) == "table" and table.concat(input, " ") or tostring(input)
end

local function show(summary, body)
	run("noctalia msg notification-show " .. quote(summary) .. " " .. quote(body) .. " >/dev/null 2>&1")
end

local last_tags

local function tally(tags)
	if tags == last_tags then
		return
	end
	last_tags = tags
	local count = 0
	while tags >= 1 do
		count = count + 1
		tags = tags / 2
	end
	show("Workspaces", count > 4 and tostring(count) or string.rep(" 󰈿", count))
end

local main_ratio, gaps, smart_gaps, offset, gaps_alt = 2 / 3, 0, true, 0, 8

function handle_layout(args)
	local retval = {}
	if args.count == 1 then
		retval[1] = smart_gaps and { 0, 0, args.width, args.height }
			or { gaps, gaps, args.width - gaps * 2, args.height - gaps * 2 }
	elseif args.count > 1 then
		local main_w = (args.width - gaps * 3) * main_ratio
		local side_w = args.width - gaps * 3 - main_w
		local side_h = (args.height - gaps) / (args.count - 1) - gaps
		retval[1] = { offset + gaps, gaps, main_w, args.height - gaps * 2 }
		for i = 0, args.count - 2 do
			retval[#retval + 1] = {
				offset + main_w + gaps * 2,
				gaps + i * (side_h + gaps),
				side_w,
				side_h,
			}
		end
	end
	-- tally(args.tags)
	return retval
end

function handle_metadata()
	return { name = "river_luatile" }
end

function modify_main_ratio(amount)
	main_ratio = math.max(0.1, math.min(0.9, main_ratio + amount * 0.01))
end

function set_main_ratio(n)
	main_ratio = math.max(0.1, math.min(0.9, tonumber(n) or 0.5))
end

function set_gaps(n)
	gaps = math.max(0, tonumber(n) or 0)
	smart_gaps = false
end

function toggle_smart_gaps()
	smart_gaps = not smart_gaps
end

function set_offset(n)
	offset = tonumber(n) or 0
end

function toggle_gaps()
	gaps, gaps_alt = gaps_alt, gaps
end

function reset_layout()
	main_ratio, gaps, smart_gaps, offset, gaps_alt = 2 / 3, 0, true, 0, 8
end

local function tofi_options()
	local opts = {}
	for key, val in pairs(config().tofi or {}) do
		opts[key] = val
	end
	return opts
end

local function tofi_command(options)
	local command = "tofi"
	for key, val in pairs(options) do
		command = command .. " --" .. key .. "=" .. quote(val)
	end
	return command
end

local function pick(prompt, items)
	local values, labels = {}, {}
	for i, item in ipairs(items) do
		labels[i] = item[1]
		values[item[1]] = item[2]
	end
	local opts = tofi_options()
	opts["prompt-text"] = prompt
	local command = "printf '%s\\n' " .. quote(table.concat(labels, "\n")) .. " | " .. tofi_command(opts)
	local handle = io.popen(command)
	local selected = handle and handle:read("*l")
	if handle then
		handle:close()
	end
	return selected and values[selected] or nil
end

local function ask(prompt)
	local opts = tofi_options()
	opts.width, opts.height = "33%", "10%"
	opts["prompt-text"] = prompt .. " "
	opts["require-match"] = "false"
	local handle = io.popen(tofi_command(opts))
	local result = handle and handle:read("*a") or ""
	if handle then
		handle:close()
	end
	return (result:gsub("%s+$", ""))
end

local function layout_cmd(command)
	return 'riverctl send-layout-cmd luatile "' .. command .. '"'
end

local function ratio_menu()
	local selected = pick("Main ratio", {
		{ "+5%", layout_cmd("modify_main_ratio(5)") },
		{ "-5%", layout_cmd("modify_main_ratio(-5)") },
		{ "50%", layout_cmd("set_main_ratio(0.5)") },
		{ "60%", layout_cmd("set_main_ratio(0.6)") },
		{ "66%", layout_cmd("set_main_ratio(0.66)") },
		{ "75%", layout_cmd("set_main_ratio(0.75)") },
		{ "Set custom...", "custom" },
	})
	if selected == "custom" then
		local n = ask("Main ratio (0.1-0.9)")
		if n ~= "" then
			run(layout_cmd("set_main_ratio(" .. n .. ")"))
			show("aquamoon2", "Main ratio: " .. n)
		end
	elseif selected then
		run(selected)
	end
end

local function gaps_menu()
	local selected = pick("Gaps", {
		{ "Toggle gaps (0 ↔ 8)", layout_cmd("toggle_gaps()") },
		{ "Gaps: 0 (smart)", layout_cmd("set_gaps(0); toggle_smart_gaps()") },
		{ "Gaps: 5", layout_cmd("set_gaps(5)") },
		{ "Gaps: 10", layout_cmd("set_gaps(10)") },
		{ "Gaps: 15", layout_cmd("set_gaps(15)") },
		{ "Set custom...", "custom" },
	})
	if selected == "custom" then
		local n = ask("Gap size (px)")
		if n ~= "" then
			run(layout_cmd("set_gaps(" .. n .. ")"))
			show("aquamoon2", "Gaps: " .. n .. "px")
		end
	elseif selected then
		run(selected)
	end
end

local function offset_menu()
	local n = ask("Offset (px)")
	if n ~= "" then
		run(layout_cmd("set_offset(" .. n .. ")"))
		show("aquamoon2", "Offset: " .. n .. "px")
	end
end

local function menu()
	local selected = pick("Layout", {
		{ "Main ratio...", ratio_menu },
		{ "Gaps...", gaps_menu },
		{ "Smart gaps", layout_cmd("toggle_smart_gaps()") },
		{ "Offset...", offset_menu },
		{ "Reset defaults", layout_cmd("reset_layout()") },
	})
	if type(selected) == "function" then
		selected()
	elseif selected then
		run(selected)
	end
end

local function apply()
	local settings = config()

	for _, input in pairs(settings.inputs or {}) do
		for key, val in pairs(input) do
			if key ~= "device" then
				run(("riverctl input %s %s %s"):format(input.device, key, value(val)))
			end
		end
	end

	local startup = {}
	for key, command in pairs(settings.startup or {}) do
		startup[#startup + 1] = { tonumber(key) or math.huge, command }
	end
	table.sort(startup, function(a, b) return a[1] < b[1] end)
	for _, entry in ipairs(startup) do
		run("riverctl spawn " .. quote(value(entry[2])))
	end

	for key, val in pairs(settings.river_options or {}) do
		run(("riverctl %s %s"):format(key, value(val)))
	end

	for kind, modes in pairs({ map = settings.map, ["map-pointer"] = settings["map-pointer"] }) do
		for mode, group in pairs(modes or {}) do
			for _, binding in ipairs(group.bindings or {}) do
				local opt = (binding.opt == "release" or binding.opt == "repeat")
					and ("-" .. binding.opt) or ""
				local mods = type(binding.mod) == "table"
					and table.concat(binding.mod, "+") or binding.mod or "None"
				local command = ("riverctl %s %s %s %s %s %s"):format(
					kind, opt, mode, mods, binding.key, value(binding.command)
				)
				run(command)
				if mode == "locked" then
					run((command:gsub(" locked ", " normal ", 1)))
				end
			end
		end
	end

	for i = 1, 9 do
		local tag = 1 << (i - 1)
		run(("riverctl map normal Super %d set-focused-tags %d"):format(i, tag))
		run(("riverctl map normal Super+Shift %d set-view-tags %d"):format(i, tag))
		run(("riverctl map normal Super+Control %d toggle-focused-tags %d"):format(i, tag))
		run(("riverctl map normal Super+Alt %d toggle-view-tags %d"):format(i, tag))
	end
	local all_tags = (1 << 32) - 1
	run(("riverctl map normal Super 0 set-focused-tags %d"):format(all_tags))
	run(("riverctl map normal Super+Shift 0 set-view-tags %d"):format(all_tags))

	for rule, apps in pairs(settings.window_rules or {}) do
		for _, app in pairs(apps) do
			run(("riverctl rule-add -app-id %s %s"):format(app, rule))
		end
	end
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
	for _, dep in ipairs({ "lua", "river", "river-luatile", "riverctl", "tofi", "noctalia", "neovide" }) do
		local ok = os.execute("command -v " .. dep .. " >/dev/null 2>&1")
		if ok ~= true and ok ~= 0 then
			missing[#missing + 1] = dep
		end
	end
	if #missing > 0 then
		print("missing: " .. table.concat(missing, " "))
	end

	local config_dir = os.getenv("XDG_CONFIG_HOME")
	if not config_dir or config_dir == "" then
		config_dir = home .. "/.config"
	end
	run("mkdir -p " .. quote(config_dir .. "/river") .. " "
		.. quote(config_dir .. "/river-luatile") .. " " .. quote(config_dir .. "/noctalia"))

	local init = assert(io.open(config_dir .. "/river/init", "w"))
	init:write("#!/bin/sh\nexec lua " .. repo .. "/lua/aquamoon.lua init\n")
	init:close()
	run("chmod +x " .. quote(config_dir .. "/river/init"))
	run("ln -sfn " .. quote(repo .. "/lua/aquamoon.lua") .. " "
		.. quote(config_dir .. "/river-luatile/layout.lua"))
	link(repo .. "/toml/noctalia.toml", config_dir .. "/noctalia/config.toml")

	if readlink(config_dir .. "/nvim") ~= repo then
		print("link Neovim config: ln -s " .. quote(repo) .. " " .. quote(config_dir .. "/nvim"))
	end
	print("configured; start the session with: river")
end

local mode = arg and arg[1]
if mode == "setup" then
	setup()
elseif mode == "menu" then
	menu()
elseif mode == "init" then
	apply()
end
