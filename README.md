# AQUAMOON2-RIVER

An Arch Linux desktop running river 0.5 with Lua.

The vendored `wm/wm.lua` is a floating window manager forked from [tinyrwm](https://codeberg.org/river/tinyrwm). Aquamoon adds TOML keybindings, tags, borders, startup commands, window rules and click-to-focus.

## Install

```sh
sudo pacman -S river base-devel wayland-protocols noctalia neovide television bat ripgrep git wl-clipboard tree-sitter-cli cosmic-files cosmic-player cosmic-viewer starship tombi upower
```

Optional: `noctalia-greeter` + `greetd`, `tofi` (AUR), `lua-language-server`.

Then:

```sh
cd ~/.aquamoon
./bin/lush setup.lush
river
```

Starts with `river`. No luarocks needed, everything is vendored.

## Keybindings

| Key | Action |
|:----|:-------|
| `Super+Return` | neovide |
| `Super+A`/`S` | neovide with tv channels |
| `Super+D` | Noctalia launcher |
| `Super+W` | window switcher |
| `Super+C` | control center |
| `Super+1-9` | show tag |
| `Super+Shift+1-9` | assign window to tag |
| `Super+Q` | close window |
| `Super+Shift+F` | fullscreen |
| `Super+F` | cosmic-files |
| `Super+B`/`N` | volume down/up |
| `Super+V`/`M` | brightness down/up |

Keys are XKB names: `Super+D` is `Super+d` lowercase. See `toml/river-bindings.toml` for the full list.

## Configuration

Everything lives in `toml/`:
- `aquamoon.toml` - borders, window rules, startup
- `river-bindings.toml` - keybindings
- `inputs.toml` - libinput devices
- `noctalia.toml` - shell settings
- `theme.toml` - palette and wallpaper

Edit, restart river, done.

## Plugins

Enabled in `toml/plugins.toml`. Includes kaomoji, notes, timer, translator, wallhaven, world clock, and theme switcher.

Toggle panels with:
```sh
noctalia msg panel-toggle noctalia/notes:panel
```
