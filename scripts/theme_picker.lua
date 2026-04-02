-- Theme picker for Aquamoon
-- Opens a menu to select and apply desktop themes

local M = {}

local S = dofile(os.getenv("HOME") .. "/.aquamoon/settings.lua")
local TT = dofile(S.path .. "/etc/tinytoml.lua")

local tofi_style = S.theme.tofi
local menu = dofile(S.path .. "/scripts/tofi.lua").opener.options(tofi_style)

local theme_list = S.theme_list

local display_list = {}
local value_map = {}
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
choice = choice:match("^%s*(.-)%s*$")
local actual_theme = value_map[choice] or choice

local toml_settings = TT.parse(os.getenv("HOME") .. "/.aquamoon/rocks.toml")
local cmd = [[sed -i 's/"]] .. toml_settings.config.colorscheme ..
    [["/"]] .. actual_theme ..
    [["/g' ~/.aquamoon/rocks.toml]]
os.execute(string.gsub(cmd, "\n", ""))

local write_configs = dofile(os.getenv("HOME") .. "/.aquamoon/scripts/write_configs.lua")
write_configs.update_all(actual_theme)

os.execute "killall river-luatile"

dofile(S.path .. "/river/init.lua")

return M
