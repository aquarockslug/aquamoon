-- Clipboard history menu
-- Opens tofi to select and copy from clipboard history

local M = {}

local home = os.getenv("HOME")
local history_path = home .. "/.aquamoon/clipboard_history"
local S = dofile(home .. "/.aquamoon/settings.lua")
local tofi = dofile(S.path .. "/scripts/sys/tofi.lua")

local function read_history()
	local entries = {}
	local file = io.open(history_path, "r")
	if file then
		local count = 0
		for line in file:lines() do
			table.insert(entries, line)
			count = count + 1
			if count > 100 then break end
		end
		file:close()
	end
	return entries
end

local function copy_to_clipboard(content)
	local handle = io.popen("wl-copy", "w")
	if handle then
		handle:write(content)
		handle:close()
	end
end

local function truncate(str, max_len)
	if #str > max_len then
		return string.sub(str, 1, max_len - 3) .. "..."
	end
	return str
end

local function open_clipboard_menu()
	local entries = read_history()

	if #entries == 0 then
		return
	end

	local choices = {}
	for _, entry in ipairs(entries) do
		table.insert(choices, truncate(entry, 100))
	end

	local options = {
		font = S.theme.active_font.path,
		["font-size"] = S.theme.active_font.size,
		width = "33%",
		height = "50%",
		["outline-width"] = 0,
		["prompt-text"] = "Copy: ",
		["selection-color"] = S.theme.text_secondary,
		["border-width"] = S.theme.border_width,
		["text-color"] = S.theme.text_primary,
		["border-color"] = S.theme.background_alt,
		["background-color"] = S.theme.background,
		["text-cursor"] = "true",
		["result-spacing"] = 9,
		anchor = "center",
		["margin-bottom"] = S.theme.border_width
	}

	local choice = tofi.opener.choices(choices).options(options).open()

	if choice and #choice > 0 then
		copy_to_clipboard(choice)
	end
end

M.open = open_clipboard_menu
M.open()

return M

