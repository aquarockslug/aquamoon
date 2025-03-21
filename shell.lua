-- LUSH LUNAR SHELL CONFIGURATION
local lush = lush -- prevent lsp warnings

-- ENVIROMENT
local home = lush.getenv("HOME")
local aqua_path = home .. "/.aquamoon"

lush.setenv("SHELL", "lush")
lush.setenv("BROWSER", "luakit")
lush.setenv("EDITOR", "nvim -u " .. aqua_path .. "/editor.lua")

-- ALIAS
lush.alias("q", "exit")
lush.alias("s", "sudo")
lush.alias("df", "duf")
lush.alias("h", "help")
lush.alias("hist", "cat " .. home .. "/.lush/.history")
lush.alias("cd ..", "cd ../")
lush.alias("..", "cd ../")
lush.alias("...", "cd ../../")
lush.alias("cls", "clear && ls")
lush.alias("l", "clear && ls")
lush.alias("lg", "lazygit")
lush.alias("v", lush.getenv("EDITOR"))
lush.alias("nvim", lush.getenv("EDITOR"))

-- TODO softclone() { git clone ssh://soft/$(ssh soft repo list | peco) }
-- TODO take() { mkdir $1 && cd $1 }

-- BEHAVIOR
lush.setPrompt("%w 󰈿")
lush.suggestions(true)
lush.altShell("bash")

-- INIT
-- open lf if it isnt already open TODO make optional with keybind
-- if not lush.getenv("LF_LEVEL") then lush.exec("lf") end
