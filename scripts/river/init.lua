-- River window manager initialization script for Aquamoon
-- Configures inputs, applies settings, and starts background processes
-- Picks a random theme on each startup
--
-- Startup flow:
--   ~/.config/river/init (bash) -> init.lua -> pick random theme -> write to rocks.toml
--   -> settings.lua reads theme -> apply river settings & wallpaper -> write app configs

local M = {}

if not AQUAMOON_SKIP_RANDOM then
	local TT = dofile(os.getenv("HOME") .. "/.aquamoon/scripts/sys/tinytoml.lua")
	local themes = TT.parse(os.getenv("HOME") .. "/.aquamoon/toml/themes.toml")
	local theme_names = {}
	for name, _ in pairs(themes) do
		if name ~= "active_font" then
			table.insert(theme_names, name)
		end
	end
	math.randomseed(os.time())
	local new_theme = theme_names[math.random(#theme_names)]
	local rocks_theme = new_theme:gsub("_", "-")
	local rocks = TT.parse(os.getenv("HOME") .. "/.aquamoon/rocks.toml")
	local cmd = [[sed -i 's/"]] .. rocks.config.colorscheme ..
		[["/"]] .. rocks_theme ..
		[["/g' ~/.aquamoon/rocks.toml]]
	os.execute(string.gsub(cmd, "\n", ""))
end

os.execute("riverctl input pointer-1149-8264-Kensington_Eagle_Trackball pointer-accel 4")
os.execute("riverctl input pointer-2362-8203-PIXA200B:00_093A:200B_Touchpad pointer-accel 2")
os.execute(
	"riverctl input pointer-1118-64-Microsoft_Microsoft_3-Button_Mouse_with_IntelliEye\\(TM\\) pointer-accel 3 pointer-accel 4")

local home = os.getenv("HOME")
local R = dofile(home .. "/.aquamoon/scripts/river/river.lua")
local S = dofile(home .. "/.aquamoon/scripts/sys/settings.lua")

R.apply_settings(S)
os.execute("swaybg --image " .. S.theme.background_image)

dofile(home .. "/.aquamoon/scripts/sys/write_configs.lua").update_all(S.theme_name)

return M

