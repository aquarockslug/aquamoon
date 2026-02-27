-- TODO allow this file to be used as a module

S = dofile(os.getenv("HOME") .. "/.aquamoon/settings.lua")
TT = dofile(S.path .. "/etc/tinytoml.lua")

local tofi_style = S.theme.tofi
local menu = dofile(S.path .. "/scripts/tofi.lua").options(tofi_style)

local theme_list = S.theme_list

local display_list = {}
local value_map = {}
for _, entry in ipairs(theme_list) do
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
choice = choice:match("^%s*(.-)%s*$") -- trim whitespace
local actual_theme = value_map[choice] or choice

-- use sed to replace the current colorscheme name in the rock.toml config file
local toml_settings = TT.parse(os.getenv("HOME") .. "/.aquamoon/nvim/rocks.toml")
local cmd = [[sed -i 's/"]] .. toml_settings.config.colorscheme ..
    [["/"]] .. actual_theme ..
    [["/g' ~/.aquamoon/nvim/rocks.toml]]
os.execute(string.gsub(cmd, "\n", "")) -- remove newlines and execute

-- kill river-luatile so that the init script can restart it with the new settings
os.execute "killall river-luatile"

-- restart river
dofile(S.path .. "/river/init.lua")
