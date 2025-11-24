#!/usr/bin/env lua

-- Installation script for Aquamoon
-- This script sets up the complete development environment
-- Usage: ./install.lua [--dry-run]

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
        -- print_error("Command failed with exit code: " .. result)
        return false
    end
    return true
end

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

if exec("pacman -S --needed sudo git base-devel") then
    print_success("Installed base development packages")
end
if exec("git clone https://aur.archlinux.org/yay.git") then
    print_success("Cloned yay repository")
end
if exec("cd yay && sudo -u aqua makepkg -si") then
    print_success("Built and installed yay")
end
if exec("cd .. && rm -rf yay") then
    print_success("Cleaned up yay build directory")
end

exec("yay -S --noconfirm neovide")

-- package list to install
local packages = {
    "abduco", "bat", "biome", "bluez", "bluez-utils",
    "brightnessctl", "butler", "clipse", "cosmic-files",
    "ddgr", "duf", "dunst", "dust", "eza", "fastfetch", "fd", "firefox",
    "fisher", "gimp", "git", "github-cli", "glide-browser-bin", "godot3",
    "grim", "gtklock", "htop", "lazygit", "loupe", "lua", "lua-language-server",
    "luakit", "luarocks", "man-db", "neovide", "networkmanager",
    "networkmanager-dmenu", "nwg-look", "opencode-bin", "openoffice-bin",
    "pacman-contrib", "pamixer", "pandoc-cli", "peco", "qbittorrent", "ripgrep", "river",
    "river-luatile-git", "rust", "scooter-bin", "selectdefaultapplication-git", "showtime",
    "simple-http-server-git", "smassh", "steam", "swaybg", "swayidle", "television",
    "texturepacker", "timg", "tofi-git", "ttf-bigblueterminal-nerd", "ttf-fairiesevka-term",
    "ttf-liberation-mono-nerd", "unzip", "vale-ls", "veracrypt", "vesktop",
    "vivid", "wget", "wiremix", "wl-clipboard", "wlr-randr", "yay", "youtui"
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
exec("yay -S --noconfirm --needed unzip")
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
if exec("sudo cp paths.lua /usr/share/luajit-2.1/") then
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

-- Function to safely create symlink
local function safe_symlink(source, target, description)
    -- Check if source exists
    -- if not exec("test -e " .. source) then
    --     print_error("Source file does not exist: " .. source)
    --     return false
    -- end
    
    -- Create target directory if needed
    -- local target_dir = target:match("(.*/)")
    -- if target_dir then
    --     if not exec("mkdir -p " .. target_dir) then
    --         print_error("Failed to create directory: " .. target_dir)
    --         return false
    --     end
    -- end
    --
    -- -- Remove existing symlink or file
    -- if exec("test -L " .. target) or exec("test -e " .. target) then
    --     if not exec("rm -f " .. target) then
    --         print_error("Failed to remove existing target: " .. target)
    --         return false
    --     end
    -- end
    
    -- Create symlink
    if exec("ln -sf " .. source .. " " .. target) then
        print_success("Linked " .. description)
        return true
    else
        print_error("Failed to link " .. description)
        return false
    end
end

-- Fish shell
safe_symlink("$(pwd)/config.fish", "~/.config/fish/config.fish", "fish configuration")

-- Neovim
if exec("test -d $(pwd)/nvim") then
    safe_symlink("$(pwd)/nvim", "~/.config/nvim", "neovim configuration directory")
else
    print_error("nvim directory not found")
end

-- River window manager
if exec("test -d $(pwd)/river") then
    safe_symlink("$(pwd)/river", "~/.config/river", "river configuration directory")
else
    print_error("river directory not found")
end

-- Dunst notification daemon
safe_symlink("$(pwd)/etc/dunstrc", "~/.config/dunst/dunstrc", "dunst configuration")

-- Tofi application launcher
safe_symlink("$(pwd)/scripts/tofi.lua", "~/.config/tofi/config.lua", "tofi configuration")

-- Themes
safe_symlink("$(pwd)/themes.toml", "~/.config/themes/themes.toml", "themes configuration")

-- Set up Rust
print_section("Setting up Rust")
if exec("rustup default stable") then
    print_success("Set Rust to stable toolchain")
end

print_section(colors.green .. colors.bold .. "Installation complete!" .. colors.reset)
print(colors.green .. "✓ Your aquamoon environment has been set up successfully!" .. colors.reset)
print(colors.blue .. "ℹ Please restart your shell or run 'source ~/.config/fish/config.fish' to apply changes." .. colors.reset)
