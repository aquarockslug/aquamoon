-- Luakit
-- https://wiki.archlinux.org/title/Luakit
-- Luakit looks for the rc and theme files in ~/.config/luakit

local modes = require "modes"

modes.add_binds("normal", {
-- {"<key>",
--  "<description>",
--  function (w) w:enter_cmd("<command>") end}
  {"O", "Open URL in a new tab.",
   function (w) w:enter_cmd(":tabopen ") end},
   ...
})

settings.window.home_page = "www.google.com"
