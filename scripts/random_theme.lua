-- Random theme changer for Aquamoon
-- Randomly selects and applies a desktop theme

local S = dofile(os.getenv("HOME") .. "/.aquamoon/settings.lua")
local TT = dofile(S.path .. "/etc/tinytoml.lua")

local themes_toml = TT.parse(os.getenv("HOME") .. "/.aquamoon/toml/themes.toml")

local available_themes = {}
for name, _ in pairs(themes_toml) do
	if name ~= "active_font" then
		table.insert(available_themes, name)
	end
end

math.randomseed(os.time())
local current_theme = S.theme_name
local new_theme = current_theme

while new_theme == current_theme do
	new_theme = available_themes[math.random(#available_themes)]
end

local toml_settings = TT.parse(os.getenv("HOME") .. "/.aquamoon/rocks.toml")
local cmd = [[sed -i 's/"]] .. toml_settings.config.colorscheme ..
    [["/"]] .. new_theme ..
    [["/g' ~/.aquamoon/rocks.toml]]
os.execute(string.gsub(cmd, "\n", ""))

local write_configs = dofile(os.getenv("HOME") .. "/.aquamoon/scripts/write_configs.lua")
write_configs.update_all(new_theme)

os.execute "killall river-luatile"

local notify = dofile(os.getenv("HOME") .. "/.aquamoon/scripts/notify.lua")
notify.send("Theme switched to: " .. new_theme)

dofile(S.path .. "/river/init.lua")