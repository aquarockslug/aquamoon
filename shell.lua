-- echo "/usr/bin/lush" | sudo tee -a /etc/shells >/dev/null

-- This file is the init.lua for lush
-- lush will look for it at $HOME/.lush/init.lua

-- Setting environment variables
local path = lush.getenv("HOME") .. "/bin:" .. lush.getenv("PATH")
lush.setenv("PATH", path)

-- you can choose to enable/disable inline suggestions
lush.suggestions(true)

-- the prompt can be customized here too
-- %u is username, %h is hostname, %w is current working directory
-- %t is current time in hr:min:sec, %d is date in MM/DD/YYYY
lush.setPrompt("[%u@%h: %w]")

-- aliases can be defined using the alias method by passing the alias name
-- and the command to execute with the alias
lush.alias("h", "help")

-- you can set a backup shell for functionality not supported by Lunar Shell
-- lush.altShell("bash")

-- all functions from the Lunar Shell Lua API are available to you to
-- customize your startup however you want
