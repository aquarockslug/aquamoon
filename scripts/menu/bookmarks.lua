-- Bookmark manager for Aquamoon
-- Reads bookmarks from TOML and opens selected URL in browser

package.path = package.path .. ";" .. os.getenv("HOME") .. "/.aquamoon/?.lua"
local S = require("scripts/sys/settings")
local tofi = require("scripts/sys/tofi").opener
local TT = require("scripts/sys/tinytoml")

local function get_bookmarks_path()
	local home = os.getenv("HOME") or os.getenv("USERPROFILE")
	return home .. "/.aquamoon/toml/bookmarks.toml"
end

local function main()
	local bookmarks_path = get_bookmarks_path()
	local bookmarks = TT.parse(bookmarks_path)

	if not bookmarks or next(bookmarks) == nil then
		print("No bookmarks found in " .. bookmarks_path)
		os.exit(1)
	end

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

	local tofi_style = S.theme.tofi
	tofi_style.prompt = [["Open URL: "]]
	local selector = tofi.choices(choices).options(tofi_style)

	local selection = selector.open():gsub("%s+$", "")

	if selection and selection ~= "" then
		local url = url_map[selection]
		if url then
			os.execute([[riverctl spawn 'xdg-open "]] .. url .. [["']])
			print("Opening: " .. url)
		else
			print("Error: URL not found for selection")
		end
	end
end

main()
