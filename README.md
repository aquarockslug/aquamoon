# AQUAMOON2-RIVER

An [Arch Linux](https://archlinux.org) desktop environment configured with Lua.

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
| `Super+O` | luatile layout menu (tofi) |
| `Super+H` / `Super+L` | focus tag 1 / 2 |
| `Super+Shift+H` / `Super+Shift+L` | shrink / grow the main area |
| `Super+1` - `Super+9` | focus tag |
| `Super+Shift+1` - `Super+Shift+9` | view tag |
| `Super+Control+1` - `Super+Control+9` | toggle focused tag |
| `Super+Alt+1` - `Super+Alt+9` | toggle view tag |
| `Super+0` | focus all tags |
| `Super+Q` | close view |
| `Super+E` | toggle float |
| `Super+Shift+F` | fullscreen |
| `Super+Shift+S` | Noctalia screenshot (region) |
| `Super+B` / `Super+N` | volume down / up |
| `Super+V` / `Super+M` | brightness down / up |
| `XF86Audio*` / `XF86MonBrightness*` | volume, mute and brightness keys |
| `Super+BTN_LEFT` / `Super+BTN_RIGHT` | move / resize view |

> **Note**
> The keys of `toml/aquamoon.toml` are XKB keysym names, so the uppercase
> letters are the lowercase ones: `Super+D` is `Super+d`. `Shift` is a
> modifier of its own, `Super+S` and `Super+Shift+S` are different bindings.

## Configuration

River settings, inputs, startup commands, and keybindings live in
`toml/aquamoon.toml`. River startup, layout, and the layout menu live in
`lua/aquamoon.lua`. Run `lua lua/aquamoon.lua setup` once to install the
session wrappers.

## Theme

Noctalia generates the Neovim palette from the active theme (`toml/nvim-template.lua`), and `init.lua` applies it with `mini.base16`. The shell palette and font are configured in `toml/noctalia.toml`.
