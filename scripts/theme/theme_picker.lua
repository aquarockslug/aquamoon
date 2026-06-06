-- Theme picker for Aquamoon
-- Opens a menu to select and apply desktop themes

local M = {}

local S = dofile(os.getenv("HOME") .. "/.aquamoon/scripts/sys/settings.lua")
local TT = dofile(S.path .. "/scripts/sys/tinytoml.lua")

local tofi_style = S.theme.tofi
local menu = dofile(S.path .. "/scripts/sys/tofi.lua").opener.options(tofi_style)

local theme_list = S.theme_list

local display_list = {}
local value_map = {}
table.insert(display_list, "Random")
value_map["Random"] = "random"
for _, entry in pairs(theme_list) do
	local display_name, value
	if type(entry) == "table" then
		display_name = entry.d or entry[1]
		value = entry.v or entry[2] or entry[1]
	else
		display_name = entry
		value = entry
	end
	table.insert(display_list, display_name)
	value_map[display_name] = value
end

local choice = menu.choices(display_list).open()
if not choice or choice == "" then
	return M
end
choice = choice:match("^%s*(.-)%s*$")
local actual_theme = value_map[choice] or choice

if actual_theme == "random" then
	local random_theme = dofile(S.path .. "/scripts/theme/random.lua")
	return M
end

local toml_settings = TT.parse(os.getenv("HOME") .. "/.aquamoon/rocks.toml")
local cmd = [[sed -i 's/"]] .. toml_settings.config.colorscheme ..
    [["/"]] .. actual_theme ..
    [["/g' ~/.aquamoon/rocks.toml]]
os.execute(string.gsub(cmd, "\n", ""))

local write_configs = dofile(os.getenv("HOME") .. "/.aquamoon/scripts/sys/write_configs.lua")
actual_theme = actual_theme:gsub("-", "_")
write_configs.update_all(actual_theme)

os.execute "killall river-luatile"

local notify = dofile(os.getenv("HOME") .. "/.aquamoon/scripts/sys/notify.lua")
notify.send("Theme switched to: " .. actual_theme)

dofile(S.path .. "/scripts/river/init.lua")

return M
