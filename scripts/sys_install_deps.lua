#!/usr/bin/env lua5.1

-- Dependency installer for Aquamoon
-- Installs and verifies required packages on Arch Linux

local M = {}

local lfs_available, lfs = pcall(require, "lfs")

local VERSION = "1.0.0"

local RED   = "\27[31m"
local GREEN = "\27[32m"
local YELLOW= "\27[33m"
local BLUE  = "\27[34m"
local CYAN  = "\27[36m"
local BOLD  = "\27[1m"
local RESET = "\27[0m"

local opts = {
    minimal = false,
    full = true,
    verbose = false,
    verify_only = false,
    skip_aur = false,
}

local CORE_PACKAGES = {
    "river",
    "river-luatile",
    "tofi",
    "dunst",
    "swaybg",
    "swayidle",
    "gtklock",
    "grim",
    "slurp",
    "wl-clipboard",
    "brightnessctl",
    "pamixer",
    "eza",
    "dust",
    "duf",
    "htop",
    "lazygit",
    "chafa",
    "neovide",
    "firefox",
    "networkmanager",
    "gammastep",
    "wofi",
    "rofi",
    "playerctl",
    "network-manager-applet",
    "blueman",
    "polkit-gnome",
    "libnotify",
    "dbus",
}

local EXTRA_PACKAGES = {
    "godot",
    "gimp",
    "mpv",
    "imv",
    "qutebrowser",
    "steam",
    "discord",
    "fzf",
    "ripgrep",
    "fd",
    "exa",
    "w3m",
    "btop",
    "bottom",
    "fastfetch",
    "arch-wiki-docs",
    "arch-wiki-lite",
}

local AUR_PACKAGES = {
    "hilbish-git",
    "networkmanager_dmenu",
    "gtklock-modules",
    "swaylock-effects",
    "river-vector-git",
}

local COMMANDS = {
    "river",
    "riverctl",
    "river-luatile",
    "tofi",
    "tofi-drun",
    "dunst",
    "dunstify",
    "grim",
    "slurp",
    "wl-copy",
    "wl-paste",
    "brightnessctl",
    "pamixer",
    "neovide",
    "hilbish",
}

local AUR_HELPER = nil
local USE_SUDO = "sudo"

local function usage()
    print(BOLD .. "aquamoon-deps" .. RESET .. " - Install dependencies for Aquamoon desktop environment")
    print()
    print(BOLD .. "USAGE:" .. RESET)
    print("    " .. arg[0] .. " [OPTIONS]")
    print()
    print(BOLD .. "OPTIONS:" .. RESET)
    print("    -m, --minimal      Install only essential packages (default: off)")
    print("    -f, --full         Install all packages including extras (default: on)")
    print("    -v, --verbose      Show detailed output")
    print("    --verify-only      Only verify installed packages, don't install")
    print("    --skip-aur         Skip AUR packages")
    print("    -h, --help         Show this help message")
    print("    -V, --version      Show version info")
    print()
    print(BOLD .. "EXAMPLES:" .. RESET)
    print("    " .. arg[0] .. "                  # Full installation with verification")
    print("    " .. arg[0] .. " --minimal        # Install only essential packages")
    print("    " .. arg[0] .. " --verify-only    # Check what's installed/missing")
    print("    " .. arg[0] .. " -v --full        # Verbose full installation")
    os.exit(0)
end

local function version()
    print("aquamoon-deps version " .. VERSION)
    os.exit(0)
end

local function log_info(msg)   print(GREEN .. "[+]" .. RESET .. " " .. msg) end
local function log_warn(msg)  print(YELLOW .. "[!]" .. RESET .. " " .. msg) end
local function log_error(msg)  print(RED .. "[X]" .. RESET .. " " .. msg) end
local function log_debug(msg)
    if opts.verbose then
        print(BLUE .. "[D]" .. RESET .. " " .. msg)
    end
end

local function run(cmd)
    log_debug("Running: " .. cmd)
    local handle = io.popen(cmd .. " 2>&1")
    local result = handle:read("*a")
    handle:close()
    local code = os.execute(cmd)
    return result, code
end

local function check_arch()
    local f = io.open("/etc/arch-release", "r")
    if not f then
        log_error("This script is designed for Arch Linux only")
        os.exit(1)
    end
    f:close()
    log_debug("Detected Arch Linux")
end

local function check_root()
    if os.getenv("EUID") == "0" then
        log_warn("Running as root - will use sudo for package installation")
        USE_SUDO = ""
    else
        USE_SUDO = "sudo"
    end
end

local function check_aur_helper()
    log_debug("Checking for AUR helper...")

    local helpers = {paru = "paru", yay = "yay", trizen = "trizen"}
    for name, cmd in pairs(helpers) do
        local handle = io.popen("which " .. cmd .. " 2>/dev/null")
        local result = handle:read("*a")
        handle:close()
        if result and result:match("^/") then
            AUR_HELPER = cmd
            log_debug("Found AUR helper: " .. AUR_HELPER)
            return
        end
    end

    if not opts.skip_aur then
        log_warn("No AUR helper found (paru/yay/trizen). AUR packages will be skipped.")
        log_warn("Install paru: https://github.com/Morganamilo/paru")
    end
    AUR_HELPER = nil
end

local function package_installed(pkg)
    local _, code = run("pacman -Q " .. pkg .. " > /dev/null 2>&1")
    return code == 0
end

local function command_exists(cmd)
    local _, code = run("which " .. cmd .. " > /dev/null 2>&1")
    return code == 0
end

local function verify_installation()
    local missing_pkgs = {}
    local missing_cmds = {}
    local status = 0

    print()
    print(BOLD .. "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" .. RESET)
    print(BOLD .. "  VERIFICATION REPORT" .. RESET)
    print(BOLD .. "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" .. RESET)
    print()

    print(CYAN .. "Core Packages:" .. RESET)
    for _, pkg in ipairs(CORE_PACKAGES) do
        if package_installed(pkg) then
            print("  " .. GREEN .. "✓" .. RESET .. " " .. pkg)
        else
            print("  " .. RED .. "✗" .. RESET .. " " .. pkg)
            table.insert(missing_pkgs, pkg)
            status = 1
        end
    end

    print()
    print(CYAN .. "Commands (runtime check):" .. RESET)
    for _, cmd in ipairs(COMMANDS) do
        if command_exists(cmd) then
            print("  " .. GREEN .. "✓" .. RESET .. " " .. cmd)
        else
            print("  " .. RED .. "✗" .. RESET .. " " .. cmd)
            table.insert(missing_cmds, cmd)
            status = 1
        end
    end

    if opts.full then
        print()
        print(CYAN .. "Extra Packages:" .. RESET)
        for _, pkg in ipairs(EXTRA_PACKAGES) do
            if package_installed(pkg) then
                print("  " .. GREEN .. "✓" .. RESET .. " " .. pkg)
            else
                print("  " .. RED .. "✗" .. RESET .. " " .. pkg)
                table.insert(missing_pkgs, pkg)
                status = 1
            end
        end
    end

    if AUR_HELPER and not opts.skip_aur then
        print()
        print(CYAN .. "AUR Packages:" .. RESET)
        for _, pkg in ipairs(AUR_PACKAGES) do
            if package_installed(pkg) then
                print("  " .. GREEN .. "✓" .. RESET .. " " .. pkg)
            else
                print("  " .. RED .. "✗" .. RESET .. " " .. pkg)
                table.insert(missing_pkgs, pkg)
                status = 1
            end
        end
    end

    print()
    print(BOLD .. "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" .. RESET)

    if #missing_pkgs > 0 then
        print()
        log_warn("Missing packages: " .. table.concat(missing_pkgs, ", "))
    end

    if #missing_cmds > 0 then
        print()
        log_warn("Commands not in PATH (may need logout/reload): " .. table.concat(missing_cmds, ", "))
    end

    print()
    if status == 0 then
        log_info("All dependencies verified!")
    else
        log_error("Some dependencies are missing. Run with install privileges to fix.")
    end

    return status
end

local function install_packages()
    local to_install = {}

    print()
    print(BOLD .. "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" .. RESET)
    print(BOLD .. "  INSTALLING PACKAGES" .. RESET)
    print(BOLD .. "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" .. RESET)
    print()

    log_info("Checking " .. #CORE_PACKAGES .. " core packages...")
    for _, pkg in ipairs(CORE_PACKAGES) do
        if not package_installed(pkg) then
            table.insert(to_install, pkg)
        else
            log_debug(pkg .. " already installed")
        end
    end

    if #to_install > 0 then
        log_info("Installing core packages: " .. table.concat(to_install, ", "))
        local _, code = run(USE_SUDO .. " pacman -S --needed " .. table.concat(to_install, " "))
        if code ~= 0 and code ~= nil then
            log_error("Failed to install some core packages")
        end
    else
        log_info("All core packages already installed")
    end

    if opts.full then
        to_install = {}
        log_info("Checking " .. #EXTRA_PACKAGES .. " extra packages...")
        for _, pkg in ipairs(EXTRA_PACKAGES) do
            if not package_installed(pkg) then
                table.insert(to_install, pkg)
            end
        end

        if #to_install > 0 then
            log_info("Installing extra packages: " .. table.concat(to_install, ", "))
            local _, code = run(USE_SUDO .. " pacman -S --needed " .. table.concat(to_install, " "))
            if code ~= 0 and code ~= nil then
                log_error("Failed to install some extra packages")
            end
        else
            log_info("All extra packages already installed")
        end
    end

    if AUR_HELPER and not opts.skip_aur then
        to_install = {}
        log_info("Checking " .. #AUR_PACKAGES .. " AUR packages...")
        for _, pkg in ipairs(AUR_PACKAGES) do
            if not package_installed(pkg) then
                table.insert(to_install, pkg)
            end
        end

        if #to_install > 0 then
            log_info("Installing AUR packages: " .. table.concat(to_install, ", "))
            local _, code = run(AUR_HELPER .. " -S --needed " .. table.concat(to_install, " "))
            if code ~= 0 and code ~= nil then
                log_error("Failed to install some AUR packages")
            end
        else
            log_info("All AUR packages already installed")
        end
    end
end

local function parse_args()
    local i = 1
    while i <= #arg do
        local a = arg[i]
        if a == "-m" or a == "--minimal" then
            opts.minimal = true
            opts.full = false
        elseif a == "-f" or a == "--full" then
            opts.full = true
            opts.minimal = false
        elseif a == "-v" or a == "--verbose" then
            opts.verbose = true
        elseif a == "--verify-only" then
            opts.verify_only = true
        elseif a == "--skip-aur" then
            opts.skip_aur = true
        elseif a == "-h" or a == "--help" then
            usage()
        elseif a == "-V" or a == "--version" then
            version()
        else
            log_error("Unknown option: " .. a)
            usage()
        end
        i = i + 1
    end
end

M.main = function()
    parse_args()

    print(CYAN .. BOLD)
    print("╔═══════════════════════════════════════════╗")
    print("║     Aquamoon Dependencies Installer      ║")
    print("║           Version " .. VERSION .. "                    ║")
    print("╚═══════════════════════════════════════════╝")
    print(RESET)

    check_arch()
    check_root()
    check_aur_helper()

    if opts.verify_only then
        local status = verify_installation()
        os.exit(status)
    end

    install_packages()
    verify_installation()

    print()
    print(GREEN .. BOLD .. "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" .. RESET)
    log_info("Installation complete!")
    print(GREEN .. BOLD .. "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" .. RESET)
    print()
    print("Next steps:")
    print("  1. Link config: " .. CYAN .. "ln -s ~/.aquamoon ~/.config/aquamoon" .. RESET)
    print("  2. Start desktop: " .. CYAN .. "river -init ~/.aquamoon/river/init.lua" .. RESET)
    print("  (or add to your display manager)")
    print()
end

M.main()

return M