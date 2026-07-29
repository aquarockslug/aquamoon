package.path = package.path .. ";" .. os.getenv("HOME") .. "/.aquamoon/?.lua"
local S = require("scripts/sys/settings")
local tofi = require("scripts/sys/tofi").opener.options(S.theme.tofi)
local notify = require("scripts/sys/notify")

local function cmd(s)
	return 'riverctl send-layout-cmd luatile "' .. s .. '"'
end

local function prompt(question)
	local opts = {
		font = S.theme.tofi.font,
		["font-size"] = S.theme.tofi["font-size"],
		width = "33%",
		height = "10%",
		["prompt-text"] = question .. " ",
		["outline-width"] = S.theme.tofi["outline-width"],
		["selection-color"] = S.theme.tofi["selection-color"],
		["border-width"] = S.theme.tofi["border-width"],
		["text-color"] = S.theme.tofi["text-color"],
		["border-color"] = S.theme.tofi["border-color"],
		["background-color"] = S.theme.tofi["background-color"],
	}
	local cmd = "tofi"
	for k, v in pairs(opts) do
		cmd = cmd .. " --" .. k .. "=" .. v
	end
	local handle = io.popen(cmd)
	if handle then
		local result = handle:read("*a"):gsub("%s+$", "")
		handle:close()
		return result
	end
	return ""
end

local choices = tofi.choices({
	{ name = "Main Ratio...", value = "sub_ratio" },
	{ name = "Gaps...", value = "sub_gaps" },
	{ name = "Smart Gaps", value = cmd("toggle_smart_gaps()") },
	{ name = "Offset...", value = "sub_offset" },
	"--------------------------------------",
	{ name = "Reset defaults", value = cmd("reset_layout()") },
})

local sel = choices.open()

if sel == "sub_ratio" then
	local choices2 = tofi.choices({
		{ name = "+5%",    value = cmd("modify_main_ratio(5)") },
		{ name = "-5%",    value = cmd("modify_main_ratio(-5)") },
		{ name = "50%",    value = cmd("set_main_ratio(0.5)") },
		{ name = "60%",    value = cmd("set_main_ratio(0.6)") },
		{ name = "66%",    value = cmd("set_main_ratio(0.66)") },
		{ name = "75%",    value = cmd("set_main_ratio(0.75)") },
		{ name = "Set custom...", value = "prompt_ratio" },
	})
	local sel2 = choices2.open()
	if sel2 == "prompt_ratio" then
		local val = prompt("Main ratio (0.1-0.9)")
		if val ~= "" then
			os.execute(cmd("set_main_ratio(" .. val .. ")"))
			notify.send("Main ratio: " .. val)
		end
	elseif sel2 and sel2 ~= "" then
		os.execute(sel2)
	end

elseif sel == "sub_gaps" then
	local choices2 = tofi.choices({
		{ name = "Toggle gaps (0 ↔ 8)", value = cmd("toggle_gaps()") },
		{ name = "Gaps: 0 (smart)",     value = cmd("set_gaps(0); toggle_smart_gaps()") },
		{ name = "Gaps: 5",  value = cmd("set_gaps(5)") },
		{ name = "Gaps: 10", value = cmd("set_gaps(10)") },
		{ name = "Gaps: 15", value = cmd("set_gaps(15)") },
		{ name = "Set custom...", value = "prompt_gaps" },
	})
	local sel2 = choices2.open()
	if sel2 == "prompt_gaps" then
		local val = prompt("Gap size (px)")
		if val ~= "" then
			os.execute(cmd("set_gaps(" .. val .. ")"))
			notify.send("Gaps: " .. val .. "px")
		end
	elseif sel2 and sel2 ~= "" then
		os.execute(sel2)
	end

elseif sel == "sub_offset" then
	local val = prompt("Offset (px)")
	if val ~= "" then
		os.execute(cmd("set_offset(" .. val .. ")"))
		notify.send("Offset: " .. val .. "px")
	end

elseif sel and sel ~= "" then
	os.execute(sel)
end
