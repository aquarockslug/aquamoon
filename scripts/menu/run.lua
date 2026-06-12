-- Application launcher using Tofi
-- Opens a drun menu to launch applications

local S = dofile(os.getenv("HOME") .. "/.aquamoon/scripts/sys/settings.lua")
local tofi = dofile(S.path .. "/scripts/sys/tofi.lua")
tofi.opener.options(S.theme.tofi).open()
