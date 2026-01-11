-- AQUAMOON file for configuring nvim's terminal

-- function for setting environment variables in the nvim terminal
function Let(name, value)
	vim.cmd("let $" .. string.upper(name) .. " = \'" .. value .. "\'")
end

Let("histsize", "10000")
Let("savehist", "10000")

local theme = require "settings".theme
Let("ps1", "%F{#" .. theme.fg .. "}%1~%k 󰈿 %f")
Let("bat_theme", "fly16")
Let("pager", "bat --theme fly16 --style=-numbers")
Let("ddgr_colors", theme.ddgr_colors)
Let("browser", "glide-bin")
Let("git_editor", "zenity --entry --title=GIT > ")
Let("editor", "/usr/bin/neovide")

local rocks_path = os.getenv("HOME") .. "/.local/share/nvim/rocks/share/lua/5.1/?.lua;"
rocks_path = rocks_path .. os.getenv("HOME") .. "/.local/share/nvim/rocks/share/lua/5.1/?/init.lua;"
local rocks_cpath = os.getenv("HOME") .. "/.local/share/nvim/rocks/lib/lua/5.1/?.so;"
rocks_cpath = rocks_cpath .. os.getenv("HOME") .. "/.local/share/nvim/rocks/lib64/lua/5.1/?.so;"
local aquamoon_path = os.getenv("HOME") .. "/.aquamoon/?.lua;" .. os.getenv("HOME") .. "/.aquamoon/?/?.lua;"
Let("lua_path", rocks_path .. aquamoon_path .. ";")
Let("lua_cpath", rocks_cpath .. ";")

Let("path", os.getenv("PATH") .. ":/home/aqua/.local/bin")
Let("path", os.getenv("PATH") .. ":/home/aqua/.cargo/bin")
