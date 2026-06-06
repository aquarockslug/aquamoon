-- Master menu hub for Aquamoon
-- Consolidates menu scripts into one entry point

local S = dofile(os.getenv("HOME") .. "/.aquamoon/scripts/sys/settings.lua")
local tofi = dofile(S.path .. "/scripts/sys/tofi.lua").opener.options(S.theme.tofi)

local items = {
  -- { name = "Run Application",  value = "menu/run" },
  { name = "Web Search",        value = "menu/browse" },
  { name = "Bookmarks",         value = "menu/bookmarks" },
  { name = "System Actions",    value = "menu/system_menu" },
  { name = "Network Manager",   value = "menu/networkmanager" },
  { name = "Clipboard History", value = "menu/clipboard" },
  { name = "Display Scale",     value = "menu/display_scale_menu" },
}

local selection = tofi.choices(items).open()
if selection and selection ~= "" then
  os.execute("lua " .. S.path .. "/scripts/" .. selection .. ".lua")
end
