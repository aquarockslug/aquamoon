-- AQUAMOON file for configuring nvim's terminal

-- function for setting environment variables in the nvim terminal
function Let(name, value) vim.cmd("let $" .. name .. " = \'" .. value .. "\'") end

Let("HISTSIZE", "10000")
Let("SAVEHIST", "10000")

local theme = require "settings".theme
Let("PS1", "%F{#" .. theme.fg .. "}%1~%k 󰈿 %f")
Let("BAT_THEME", "fly16")
Let("PAGER", "bat --theme fly16 --style=-numbers") -- alternatives: more, nvim
Let("DDGR_COLORS", "fHgffH")

local rocks_path = os.getenv("HOME") .. "/.local/share/nvim/rocks/share/lua/5.1/?.lua;"
rocks_path = rocks_path .. os.getenv("HOME") .. "/.local/share/nvim/rocks/share/lua/5.1/?/init.lua;"
local rocks_cpath = os.getenv("HOME") .. "/.local/share/nvim/rocks/lib/lua/5.1/?.so;"
rocks_cpath = rocks_cpath .. os.getenv("HOME") .. "/.local/share/nvim/rocks/lib64/lua/5.1/?.so;"
local aquamoon_path = os.getenv("HOME") .. "/.aquamoon/?.lua;" .. os.getenv("HOME") .. "/.aquamoon/?/?.lua;"
Let("LUA_PATH", rocks_path .. aquamoon_path .. ";")
Let("LUA_CPATH", rocks_cpath .. ";")

Let("PATH", os.getenv("PATH") .. ":/home/aqua/.local/bin")

-- TODO put aliases here?
