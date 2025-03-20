-- Luakit
-- https://wiki.archlinux.org/title/Luakit

local modes = require "modes"

modes.add_binds("normal", {
  {"O", "Open URL in a new tab.",
   function (w) w:enter_cmd(":tabopen ") end},
})

Settings.window.home_page = "www.duckduckgo.com"
