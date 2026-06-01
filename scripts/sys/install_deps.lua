#!/usr/bin/env lua5.1

local home = os.getenv("HOME")
local aq = home .. "/.aquamoon"

local CORE = {
  "river", "river-luatile", "tofi", "dunst", "swaybg", "swayidle",
  "gtklock", "grim", "slurp", "wl-clipboard", "brightnessctl", "pamixer",
  "eza", "dust", "duf", "htop", "lazygit", "chafa", "neovide", "firefox",
  "networkmanager", "gammastep", "wofi", "rofi", "playerctl",
  "network-manager-applet", "blueman", "polkit-gnome", "libnotify", "dbus",
}

local EXTRA = {
  "godot", "gimp", "mpv", "imv", "qutebrowser", "steam", "discord",
  "fzf", "ripgrep", "fd", "exa", "w3m", "btop", "bottom", "fastfetch",
  "arch-wiki-docs", "arch-wiki-lite",
}

local AUR = { "hilbish-git", "networkmanager_dmenu", "gtklock-modules",
  "swaylock-effects", "river-vector-git" }

local function installed(pkg)
  return os.execute("pacman -Q " .. pkg .. " > /dev/null 2>&1") == 0
end

local function install(label, pkgs, pm)
  local need = {}
  for _, p in ipairs(pkgs) do
    if not installed(p) then table.insert(need, p) end
  end
  if #need == 0 then print("  " .. label .. ": already installed"); return end
  print("  " .. label .. ": " .. table.concat(need, " "))
  os.execute(pm .. " -S --needed " .. table.concat(need, " "))
end

print("== Installing packages ==")
install("core", CORE, "sudo pacman")
if arg[1] ~= "--minimal" then
  install("extra", EXTRA, "sudo pacman")
end
if io.popen("which paru 2>/dev/null"):read("*a"):match("/") then
  install("AUR", AUR, "paru")
else
  print("  AUR: skipped (install paru first)")
end

print("== Setting up configs ==")
local config_dirs = { "river", "dunst", "television", "lazygit" }
for _, d in ipairs(config_dirs) do
  os.execute("mkdir -p " .. home .. "/.config/" .. d)
end

local init_path = home .. "/.config/river/init"
local f = io.open(init_path, "w")
if f then
  f:write("#!/bin/bash\nlua " .. aq .. "/scripts/river/init.lua\n")
  f:close()
  os.execute("chmod +x " .. init_path)
  print("  wrote " .. init_path)
end

local ok = os.execute("lua " .. aq .. "/scripts/sys/write_configs.lua sweetie 2>/dev/null")
if ok then
  print("  generated themed configs (dunst, television, lazygit)")
end

print()
print("Done. Start with: river -init " .. aq .. "/scripts/river/init.lua")
