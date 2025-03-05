-- LUSH LUNAR SHELL CONFIGURATION

-- ENVIROMENT
local path = lush.getenv("HOME") .. "/bin:" .. lush.getenv("PATH")
lush.setenv("PATH", path)

local aqua_path = lush.getenv("HOME") .. "/.aquamoon"
lush.setenv("XDG_CONFIG_DIR", aqua_path)
lush.setenv("SHELL", "/usr/bin/lush")
lush.setenv("EDITOR", "nvim -u " .. aqua_path .. "/editor.lua")

-- ALIAS
lush.alias("q", "exit")
lush.alias("s", "sudo")
lush.alias("h", "help")
lush.alias("lg", "lazygit")
lush.alias("cls", "clear && ls")
lush.alias("v", lush.getenv("EDITOR"))

-- TODO softclone() { git clone ssh://soft/$(ssh soft repo list | peco) }

-- BEHAVIOR
lush.setPrompt("%w 󰈿")
lush.suggestions(true)
lush.altShell("bash")
