-- Theme picker for Aquamoon
-- Opens a menu to select and apply desktop themes

package.path = package.path .. ";" .. os.getenv("HOME") .. "/.aquamoon/?.lua"
local S = require("scripts/sys/settings")
local TT = require("scripts/sys/tinytoml")
local menu = require("scripts/sys/tofi").opener.options(S.theme.tofi)

local display_list = {}
local value_map = {}
table.insert(display_list, "Random")
value_map["Random"] = "random"
for _, entry in pairs(S.theme_list) do
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
	return
end
choice = choice:match("^%s*(.-)%s*$")
local actual_theme = value_map[choice] or choice

if actual_theme == "random" then
	dofile(S.path .. "/scripts/theme/random.lua")
	return
end

local toml_settings = TT.parse(os.getenv("HOME") .. "/.aquamoon/rocks.toml")
local cmd = [[sed -i 's/"]] .. toml_settings.config.colorscheme ..
    [["/"]] .. actual_theme ..
    [["/g' ~/.aquamoon/rocks.toml]]
os.execute(string.gsub(cmd, "\n", ""))

local write_configs = require("scripts/sys/write_configs")
actual_theme = actual_theme:gsub("-", "_")
write_configs.update_all(actual_theme)

os.execute "killall river-luatile"

require("scripts/sys/notify").send("Theme switched to: " .. actual_theme)

local function reload_neovim_themes()
	local handle = io.popen(
		'for sock in /run/user/1000/nvim.*.0; do '
		.. 'nvim --server "$sock" --remote-send ":AquaReloadTheme<CR>" 2>/dev/null || true; '
		.. 'done'
	)
	if handle then handle:close() end
end
reload_neovim_themes()

AQUAMOON_SKIP_RANDOM = true
dofile(S.path .. "/scripts/river/init.lua")
