-- LUSH LUNAR SHELL CONFIGURATION

-- ENVIROMENT
local home = lush.getenv("HOME")
local aqua_path = home .. "/.aquamoon"

lush.setenv("SHELL", "lush")
lush.setenv("BROWSER", "luakit")
lush.setenv("EDITOR", "nvim -u " .. aqua_path .. "/editor.lua")

-- local path = lush.getenv("PATH") .. ":" .. aqua_path .. ":" .. home .. "/.cargo/bin"
-- lush.setenv("PATH", path)
-- lush.setenv("XDG_CONFIG_DIR", aqua_path)
-- lush.setenv("XDG_CONFIG_HOME", aqua_path)

-- ALIAS
lush.alias("q", "exit")
lush.alias("s", "sudo")
lush.alias("df", "duf")
lush.alias("h", "help")
lush.alias("..", "cd ../")
lush.alias("...", "cd ../../")
lush.alias("cls", "clear && ls")
lush.alias("l", "clear && ls")
lush.alias("lg", "lazygit")
lush.alias("v", lush.getenv("EDITOR"))

-- TODO softclone() { git clone ssh://soft/$(ssh soft repo list | peco) }
-- TODO take() { mkdir $1 && cd $1 }

-- BEHAVIOR
lush.setPrompt("%w 󰈿")
lush.suggestions(true)
lush.altShell("bash")
