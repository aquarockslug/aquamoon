-- Application launcher using Tofi
-- Opens a drun menu to launch applications

package.path = package.path .. ";" .. os.getenv("HOME") .. "/.aquamoon/?.lua"
local S = require("scripts/sys/settings")
require("scripts/sys/tofi").opener.options(S.theme.tofi).open()
