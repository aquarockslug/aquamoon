local S = dofile(os.getenv("HOME") .. "/.aquamoon/settings.lua")
dofile(S.path .. "/scripts/tofi.lua")
    .options(S.theme.tofi)
    .open()
