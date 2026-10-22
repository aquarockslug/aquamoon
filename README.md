# AQUAMOON2-RIVER

An [Arch Linux](https://archlinux.org) desktop environment configured with Lua.

This branch is the **aquamoon2** neovim configuration (the one from
`~/.config/aquamoon2`) combined with the **minimum** amount of the aquamoon
`main` branch needed to run it under [river](https://github.com/riverwm/river)
with the [river-luatile](https://github.com/MaxVerevkin/river-luatile) layout
generator.

|||
|:---------|:---------|
| Windows | River + Luatile |
| Menus | Tofi |
| Notifications | Dunst |
| Editor | Neovide + Neovim (aquamoon2 config) |

## Repository layout

The neovim configuration lives at the repository root, exactly like in
`aquamoon2`, so that `~/.config/nvim -> ~/.aquamoon` keeps pointing at it:

```
init.lua               aquamoon2 neovim configuration
lua/settings.lua       aquamoon2 TOML parser for the neovim settings
settings.toml          neovim options (read by init.lua)
open_dir.lua           project picker (tofi + neovide)
paths.lua              lua_modules search path for open_dir.lua
nvim-pack-lock.json    pinned plugin versions

scripts/river/         river session, riverctl bindings, luatile layout
scripts/sys/           settings loader, TOML parser, tofi/dunst helpers
scripts/util/          setup helper, screenshot
toml/                  river options, keybindings, startup commands, inputs
```

## How it fits together

```
river (session start)
 └── ~/.config/river/init          -> scripts/river/init.lua
      ├── scripts/sys/settings.lua -> reads toml/*.toml
      ├── scripts/river/river.lua   -> riverctl options, mappings, rules
      └── riverctl spawn river-luatile
           └── reads ~/.config/river-luatile/layout.lua
                -> scripts/river/layout.lua   (the luatile layout)

river (Super+Return)
 └── env NVIM_APPNAME=nvim neovide
      └── nvim -> ~/.config/nvim -> ~/.aquamoon/init.lua (aquamoon2 config)
```

`scripts/river/layout.lua` is the layout generator river-luatile executes. It
is also the script that receives the `riverctl send-layout-cmd luatile ...`
commands used by the layout menu (`Super+O`) and by `Super+Shift+H`/`Super+Shift+L`.

## Setup

```sh
lua ~/.aquamoon/scripts/util/setup.lua
```

The helper checks the dependencies (`river`, `river-luatile`, `tofi`, `dunst`,
`neovide`, ...) and creates:

| Path | Purpose |
|:-----|:--------|
| `~/.config/river/init` | bash wrapper running `scripts/river/init.lua` |
| `~/.config/river-luatile` | symlink to `scripts/river` (river-luatile reads `layout.lua` from there) |

`~/.config/nvim` must point at this repository:

```sh
ln -s ~/.aquamoon ~/.config/nvim
```

> **Note**
> The fish universal variable `NVIM_APPNAME=mini` overrides the config
> directory for every shell. The river bindings set `NVIM_APPNAME=nvim`
> explicitly, so neovide started from river always uses this repository.
> In a plain shell, run `NVIM_APPNAME=nvim nvim` (or unset the variable).

### open_dir.lua

`open_dir.lua` needs the luarocks modules `microlight`, `luafilesystem`,
`toml-edit` and `tofi-lua`. They are installed in `lua_modules/` (git
ignored):

```sh
luarocks --tree ~/.aquamoon/lua_modules install microlight luafilesystem toml-edit tofi-lua
```

## Keybindings

| Key | Action |
|:----|:-------|
| `Super+Return` | neovide with the aquamoon2 configuration |
| `Super+A` / `Super+S` | neovide with the `tv` file/text channel |
| `Super+W` | window switcher (tofi) |
| `Super+O` | luatile layout menu (tofi) |
| `Super+H` / `Super+L` | focus tag 1 / 2 |
| `Super+Shift+H` / `Super+Shift+L` | shrink / grow the main area |
| `Super+1` - `Super+9` | focus tag, `Super+Shift+N` view tag |
| `Super+Q` | close view |
| `Super+E` | toggle float |
| `Super+Shift+F` | fullscreen |
| `Super+Shift+S` | screenshot (slurp + grim) |
| `Super+B` / `Super+N` | volume down / up |
| `Super+V` / `Super+M` | brightness down / up |
| `XF86Audio*` / `XF86MonBrightness*` | volume and brightness keys |
| `Super+BTN_LEFT` / `Super+BTN_RIGHT` | move / resize view |

## Differences from the aquamoon `main` branch

* the neovim configuration is the aquamoon2 one (`vim.pack`, `sweetie`, tv,
  oil/canola, ...) instead of the rocks.nvim based one
* no theme system: the river colours and the tofi/dunst colours are the
  `sweetie` ones and live in `toml/settings.toml`
* no menus, daemons, wallpaper, screen locker or weather widgets
* `attach-mode` was replaced by `default-attach-mode` (river 0.3.x)
* bindings without modifiers use river's `None` modifier
