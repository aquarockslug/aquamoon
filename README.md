# aquamoon

Arch + river 0.5, configured with Lua and TOML.

The vendored `wm/wm.lua` is a floating window manager forked from [tinyrwm](https://codeberg.org/river/tinyrwm). Aquamoon layers on TOML keybindings, tags, borders, window rules, and startup commands.

## install

```sh
sudo pacman -S river base-devel wayland-protocols noctalia neovide television bat ripgrep git wl-clipboard tree-sitter-cli cosmic-files cosmic-player cosmic-viewer starship tombi upower
```

Optional: `noctalia-greeter` + `greetd`, `tofi` (AUR), `lua-language-server`.

Then from the repo:

```sh
./bin/lush setup.lush
river
```

No luarocks — everything is vendored.

## config

Everything lives in `toml/` — keybindings, theme, inputs, window rules, shell, plugins. Edit, restart river, done.
