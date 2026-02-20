#!/usr/bin/env lua

-- AQUA BOOKMARKS
-- Reads bookmarks from bookmarks.toml and opens the selected URL

local S = dofile(os.getenv("HOME") .. "/.aquamoon/settings.lua")

local tofi = dofile(S.path .. "/scripts/tofi.lua")

-- Get the bookmarks file path
local function get_bookmarks_path()
	local home = os.getenv("HOME") or os.getenv("USERPROFILE")
	return home .. "/.aquamoon/etc/bookmarks.toml"
end


-- Read and parse TOML file
local function read_toml(file_path)
	local data = {}
	local current_section = nil
	local file = io.open(file_path, "r")

	if not file then
		print("Error: Could not open " .. file_path)
		return data
	end

	for line in file:lines() do
		-- Skip comments and empty lines
		if line:match("^%s*#") or line:match("^%s*$") then
			goto continue
		end

		-- Parse section headers [section]
		local section = line:match("^%[([^%]]+)%]$")
		if section then
			current_section = section
			data[current_section] = {}
			goto continue
		end

		-- Parse key = value pairs
		local key, value = line:match("^%s*(%w+)%s*=%s*\"?([^\"]*)\"?%s*$")
		if key and value and current_section then
			data[current_section][key] = value:gsub("^\"+\",\"+$", ""):gsub("^\"+\",\"+$", "")
		end

		::continue::
	end

	file:close()
	return data
end

-- Main function
local function main()
	local bookmarks_path = get_bookmarks_path()
	local bookmarks = read_toml(bookmarks_path)

	if not bookmarks or next(bookmarks) == nil then
		print("No bookmarks found in " .. bookmarks_path)
		os.exit(1)
	end

	-- Build choices list for tofi
	local choices = {}
	local url_map = {}

	for _key, bookmark in pairs(bookmarks) do
		if bookmark.name and bookmark.url then
			local display_name = bookmark.name .. " (" .. bookmark.url .. ")"
			table.insert(choices, display_name)
			url_map[display_name] = bookmark.url
		end
	end

	if #choices == 0 then
		print("No valid bookmarks found")
		os.exit(1)
	end

	-- Show tofi selector
	local tofi_style = S.theme.tofi
	tofi_style.prompt = [["Open URL: "]]
	local selector = tofi.choices(choices).options(tofi_style)

	local selection = selector.open():gsub("%s+$", "")

	if selection and selection ~= "" then
		local url = url_map[selection]
		if url then
			-- Open URL with default browser
			os.execute([[riverctl spawn 'xdg-open "]] .. url .. [["']])
			print("Opening: " .. url)
		else
			print("Error: URL not found for selection")
		end
	end
end

main()
