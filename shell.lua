-- echo "/usr/bin/lush" | sudo tee -a /etc/shells >/dev/null

-- This file is the init.lua for lush
-- lush will look for it at $HOME/.lush/init.lua

-- ENVIROMENT 
local path = lush.getenv("HOME") .. "/bin:" .. lush.getenv("PATH")
lush.setenv("PATH", path)

-- ALIAS
lush.alias("h", "help")

-- BEHAVIOR
lush.setPrompt("%w 󰈿")
lush.suggestions(true)
lush.altShell("bash")
