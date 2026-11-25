# Aquamoon

Arch + river 0.5, configured with Lua and TOML.

The vendored `wm/wm.lua` is a floating window manager forked from [tinyrwm](https://codeberg.org/river/tinyrwm). Aquamoon layers on TOML keybindings, tags, borders, window rules, and startup commands.

## Install

```sh
sudo pacman -S river base-devel wayland-protocols noctalia neovide television bat ripgrep git wl-clipboard tree-sitter-cli cosmic-files cosmic-player cosmic-viewer starship tombi upower
```

Optional: `noctalia-greeter` + `greetd`, `tofi` (AUR), `lua-language-server`.

Then from the repo:

```sh
git clone --depth 1 git@github.com:aquarockslug/lush-unsafe.git lib/lush-unsafe
cp lib/lush-unsafe/lush bin/lush
./bin/lush setup.lush
river
```
No luarocks required

## Config
All configuration is done by editing files in the toml directory

