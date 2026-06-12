-- Random theme changer for Aquamoon
-- Randomly selects and applies a desktop theme

local S = dofile(os.getenv("HOME") .. "/.aquamoon/scripts/sys/settings.lua")
local TT = dofile(S.path .. "/scripts/sys/tinytoml.lua")

local available_themes = {}
local handle = io.popen("ls " .. os.getenv("HOME") .. "/.aquamoon/toml/themes/*.toml 2>/dev/null")
if handle then
	for file in handle:lines() do
		local name = file:match("([^/]+)%.toml$")
		if name then
			table.insert(available_themes, name)
		end
	end
	handle:close()
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

local write_configs = dofile(os.getenv("HOME") .. "/.aquamoon/scripts/sys/write_configs.lua")
write_configs.update_all(new_theme)

os.execute "killall river-luatile"

local notify = dofile(os.getenv("HOME") .. "/.aquamoon/scripts/sys/notify.lua")
notify.send("Theme switched to: " .. new_theme)

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
