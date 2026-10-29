# AQUAMOON2-RIVER

An [Arch Linux](https://archlinux.org) desktop environment configured with Lua,
running on river 0.5, the newest non-monolithic
[river](https://codeberg.org/river/river) compositor, with
[tinyrwm](https://codeberg.org/river/tinyrwm) as the window manager.

The vendored `tinyrwm/tinyrwm.lua` started by the session is a small floating
window manager. Aquamoon adds TOML-driven keybindings, tags, borders, startup
commands, window rules and click-to-focus on top of the upstream tinyrwm
implementation.

## Requirements

```sh
sudo pacman -S river lua54 luarocks tofi noctalia neovide
```

The window manager runs on Lua 5.4 and uses these LuaRocks modules:

```sh
luarocks --lua-version=5.4 --local install cffi-lua
luarocks --lua-version=5.4 --local install luaposix
luarocks --lua-version=5.4 --local install wau
```

No `river-classic`, `riverctl` or `river-luatile` installation is required.

## Keybindings

| Key | Action |
|:----|:-------|
| `Super+Return` | neovide with the aquamoon2 configuration |
| `Super+A` / `Super+S` | neovide with the `tv` file/text channel |
| `Super+D` | Noctalia launcher |
| `Super+W` | Noctalia window switcher |
| `Super+C` | Noctalia control center |
| `Super+Shift+C` | Noctalia notification history (control center notifications tab) |
| `Super+Shift+V` | Noctalia clipboard history |
| `Super+Shift+W` | Noctalia wallpaper picker |
| `Super+Escape` | Noctalia session menu (logout, reboot, shutdown, ...) |
| `Super+comma` | Noctalia settings |
| `Super+Alt+L` | lock the screen (Noctalia lock screen) |
| `Super+H` / `Super+L` | show tag 1 / 2 |
| `Super+J` / `Super+K` | focus previous / next window |
| `Super+1` - `Super+9` | show tag |
| `Super+Shift+1` - `Super+Shift+9` | assign the focused window to a tag |
| `Super+Control+1` - `Super+Control+9` | toggle tag visibility |
| `Super+Alt+1` - `Super+Alt+9` | toggle the focused window's tag |
| `Super+0` | show all tags |
| `Super+Shift+0` | assign the focused window to all tags |
| `Super+Q` | close window |
| `Super+Shift+F` | fullscreen |
| `Super+F` | cosmic-files |
| `Super+Shift+S` | Noctalia screenshot (region) |
| `Super+B` / `Super+N` | volume down / up |
| `Super+V` / `Super+M` | brightness down / up |
| `XF86Audio*` / `XF86MonBrightness*` | volume, mute and brightness keys |
| `Super+BTN_LEFT` / `Super+BTN_RIGHT` | move / resize window |

> **Note**
> The keys of `toml/aquamoon.toml` are XKB keysym names, so the uppercase
> letters are the lowercase ones: `Super+D` is `Super+d`. `Shift` is a
> modifier of its own, `Super+S` and `Super+Shift+S` are different bindings.

## Configuration

River settings, startup commands, keybindings and window rules live in
`toml/aquamoon.toml`. `tinyrwm/tinyrwm.lua` reads that file directly at
startup, so changes can be tested by restarting the session.

Run `lua lua/aquamoon.lua setup` once to build and install tinyrwm, and to
install the session wrappers:

```sh
lua lua/aquamoon.lua setup
river
```

Only the options implemented by tinyrwm are used: `border-width`,
`border-color-focused`, `border-color-unfocused`, `focus-follows-cursor`
(`disabled` or `normal`) and `default-attach-mode` (`top` or `bottom`).
Window rules currently support `ssd` (server-side decorations). Pointer
acceleration and other libinput settings are not applied because tinyrwm does
not implement the river input protocols.

tinyrwm binds `river_layer_shell_v1`, so layer-shell clients such as Noctalia
panels, the launcher and notifications can map surfaces. It also marks the
first output as the default for layer surfaces and yields keyboard focus while
an exclusive layer surface is open.

## Theme

Noctalia generates the Neovim palette from the active theme (`toml/nvim-template.lua`), and `init.lua` applies it with `mini.base16`. The shell palette and font are configured in `toml/noctalia.toml`.
