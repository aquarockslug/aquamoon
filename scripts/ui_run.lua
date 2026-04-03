-- Application launcher using Tofi
-- Opens a drun menu to launch applications

local M = {}

local S = dofile(os.getenv("HOME") .. "/.aquamoon/settings.lua")
local tofi = dofile(S.path .. "/scripts/sys_tofi.lua")
tofi.opener.options(S.theme.tofi).open()

return M