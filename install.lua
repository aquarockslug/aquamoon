#!/usr/bin/env lua

-- Installation script for Aquamoon
-- This script sets up the complete development environment
-- Usage: ./install.lua [--dry-run]

local dry_run = false
if arg and arg[1] == "--dry-run" then
    dry_run = true
    print(colors.yellow .. "DRY RUN MODE - No actual commands will be executed" .. colors.reset)
end

local function exec(cmd)
    print(colors.yellow .. "→ " .. colors.reset .. cmd)
    if dry_run then
        print(colors.blue .. "[DRY RUN] Would execute: " .. cmd .. colors.reset)
        return true
    end
    local result = os.execute(cmd)
    if result ~= 0 then
        print_error("Command failed with exit code: " .. result)
        return false
    end
    return true
end

-- ANSI color codes
local colors = {
    reset = "\027[0m",
    bold = "\027[1m",
    red = "\027[31m",
    green = "\027[32m",
    yellow = "\027[33m",
    blue = "\027[34m",
    magenta = "\027[35m",
    cyan = "\027[36m",
    white = "\027[37m"
}

local function print_section(title)
    print("\n" .. colors.cyan .. colors.bold .. string.rep("═", 50) .. colors.reset)
    print(colors.cyan .. colors.bold .. "  " .. title .. colors.reset)
    print(colors.cyan .. colors.bold .. string.rep("═", 50) .. colors.reset)
end

local function print_success(msg)
    print(colors.green .. "✓ " .. msg .. colors.reset)
end

local function print_error(msg)
    print(colors.red .. "✗ " .. msg .. colors.reset)
end

local function print_info(msg)
    print(colors.blue .. "ℹ " .. msg .. colors.reset)
end

-- install yay for AUR packages
print_section("Installing yay AUR helper")
if exec("sudo pacman -S --needed git base-devel") then
    print_success("Installed base development packages")
end
if exec("git clone https://aur.archlinux.org/yay.git") then
    print_success("Cloned yay repository")
end
if exec("cd yay && makepkg -si") then
    print_success("Built and installed yay")
end
if exec("cd .. && rm -rf yay") then
    print_success("Cleaned up yay build directory")
end

-- package list to install
local packages = {
    "abduco", "arch-update", "archlinux-contrib", "bat", "biome", "bluez", "bluez-utils",
    "brightnessctl", "butler", "catppuccin-cursors-frappe", "catppuccin-cursors-latte",
    "catppuccin-gtk-theme-frappe", "catppuccin-gtk-theme-latte", "clipse", "cosmic-files",
    "ddgr", "duf", "dunst", "dust", "eza", "fastfetch", "fd", "firefox",
    "fisher", "gh-dash", "gimp", "git", "github-cli", "glide-browser-bin", "godot3",
    "grim", "gtklock", "htop", "lazygit", "loupe", "lua", "lua-language-server",
    "luakit", "luarocks", "man-db", "neovide", "networkmanager",
    "networkmanager-dmenu", "nwg-look", "opencode-bin", "openoffice-bin",
    "pacman-contrib", "pamixer", "pandoc-cli", "peco", "qbittorrent", "ripgrep", "river",
    "river-luatile-git", "rust", "scooter-bin", "selectdefaultapplication-git", "showtime",
    "simple-http-server-git", "smassh", "steam", "swaybg", "swayidle", "television",
    "texturepacker", "timg", "tofi-git", "ttf-bigblueterminal-nerd", "ttf-fairiesevka-term",
    "ttf-liberation-mono-nerd", "unzip", "vale-ls", "veracrypt", "vesktop",
    "vivid", "wget", "whitesur-cursor-theme-git", "whitesur-gtk-theme", "whitesur-icon-theme",
    "wiremix", "wl-clipboard", "wlr-randr", "yay", "youtui"
}

-- install packages in batches
print_section("Installing packages")
local batch_size = 10
for i = 1, #packages, batch_size do
    local batch = {}
    for j = i, math.min(i + batch_size - 1, #packages) do
        table.insert(batch, packages[j])
    end
    local package_str = table.concat(batch, " ")
    local batch_num = math.ceil(i/batch_size)
    local total_batches = math.ceil(#packages/batch_size)
    print_info("Installing batch " .. batch_num .. "/" .. total_batches)
    if exec("yay -S --noconfirm " .. package_str) then
        print_success("Batch " .. batch_num .. " installed successfully")
    else
        print_error("Failed to install batch " .. batch_num)
        break
    end
end

-- install rocks.nvim
print_section("Installing rocks.nvim")
if exec("nvim -u NORC -c \"source https://raw.githubusercontent.com/lumen-oss/rocks.nvim/master/installer.lua\"") then
    print_success("rocks.nvim installed successfully")
end

-- create directories and copy paths.lua
print_section("Setting up Lua paths")
if exec("sudo mkdir -p /usr/share/lua/5.4 /usr/share/luajit") then
    print_success("Created Lua directories")
end
if exec("sudo cp paths.lua /usr/share/lua/5.4/") then
    print_success("Copied paths.lua to Lua 5.4")
end
if exec("sudo cp paths.lua /usr/share/luajit/") then
    print_success("Copied paths.lua to LuaJIT")
end

-- generate SSH key and add to GitHub
print_section("Setting up SSH key")
if exec("ssh-keygen -t ed25519 -C \"$USER@$(hostname)\" -f ~/.ssh/id_ed25519 -N \"\"") then
    print_success("SSH key generated")
end
print_info("SSH key generated. Add this to GitHub:")
local _ = os.execute("cat ~/.ssh/id_ed25519.pub")
print("\n" .. colors.yellow .. "Press Enter to continue..." .. colors.reset)
io.read()

-- Create configuration symlinks
print_section("Setting up configuration symlinks")

-- Fish shell
if exec("mkdir -p ~/.config/fish") then
    print_success("Created fish config directory")
end
if exec("ln -sf $(pwd)/config.fish ~/.config/fish/config.fish") then
    print_success("Linked fish configuration")
end

-- Neovim
if exec("mkdir -p ~/.config/nvim") then
    print_success("Created nvim config directory")
end
if exec("ln -sf $(pwd)/nvim/* ~/.config/nvim/") then
    print_success("Linked neovim configuration")
end

-- River window manager
if exec("mkdir -p ~/.config/river") then
    print_success("Created river config directory")
end
if exec("ln -sf $(pwd)/river/* ~/.config/river/") then
    print_success("Linked river configuration")
end

-- Dunst notification daemon
if exec("mkdir -p ~/.config/dunst") then
    print_success("Created dunst config directory")
end
if exec("ln -sf $(pwd)/etc/dunstrc ~/.config/dunst/dunstrc") then
    print_success("Linked dunst configuration")
end

-- Tofi application launcher
if exec("mkdir -p ~/.config/tofi") then
    print_success("Created tofi config directory")
end
if exec("ln -sf $(pwd)/scripts/tofi.lua ~/.config/tofi/config.lua") then
    print_success("Linked tofi configuration")
end

-- Themes
if exec("mkdir -p ~/.config/themes") then
    print_success("Created themes config directory")
end
if exec("ln -sf $(pwd)/themes.toml ~/.config/themes/themes.toml") then
    print_success("Linked themes configuration")
end

-- Set up Rust
print_section("Setting up Rust")
if exec("rustup default stable") then
    print_success("Set Rust to stable toolchain")
end

print_section(colors.green .. colors.bold .. "Installation complete!" .. colors.reset)
print(colors.green .. "✓ Your aquamoon environment has been set up successfully!" .. colors.reset)
print(colors.blue .. "ℹ Please restart your shell or run 'source ~/.config/fish/config.fish' to apply changes." .. colors.reset)
