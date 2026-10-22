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
`aquamoon2`, so that `~/.config/nvim -> ~/.aquamoon` keeps pointing at it.
Everything else is grouped by topic:

```
init.lua               aquamoon2 neovim configuration (the entry point)
settings.toml          neovim options (read by init.lua)
projects.toml          project picker settings (read by open_dir.lua)
nvim-pack-lock.json    pinned plugin versions

scripts/river/         river session, riverctl bindings, luatile layout
scripts/sys/           settings loader, tofi/dunst helpers
scripts/util/          setup helper, paths, screenshot, launcher, picker
toml/                  river options, keybindings, startup commands, inputs
```

There is no `lua/` directory: `init.lua` sits in the repository root and reads
`settings.toml` with the `tinytoml` rock installed in `lua_modules/` (see
[Lua modules](#lua-modules)); `scripts/util/paths.lua` adds that tree to the
Lua search path, for neovim and for the scripts alike.

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

The helper checks the dependencies (the system commands and the Lua modules
listed below) and creates:

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

### Lua modules

The Lua modules the configuration needs are luarocks rocks, installed in the
git ignored `lua_modules/` directory of the repository:

| Rock | Used by |
|:-----|:--------|
| `tinytoml` | every TOML file of the configuration |
| `luafilesystem` | `scripts/util/open_dir.lua` (directory listing) |
| `tofi-lua` | `scripts/util/open_dir.lua` (the project picker) |

```sh
luarocks --tree ~/.aquamoon/lua_modules install tinytoml
luarocks --tree ~/.aquamoon/lua_modules install luafilesystem
luarocks --tree ~/.aquamoon/lua_modules install tofi-lua
```

`scripts/util/paths.lua` adds the tree to the Lua search path and every script
loads it itself, so they can be run from anywhere. neovim runs LuaJIT (5.1)
while the scripts run the system Lua (5.5); `tinytoml` is pure Lua, so the one
install serves both, while the C modules (`luafilesystem`, `tofi-lua`) are
built for the system Lua and only used by the scripts.

### Project picker

`scripts/util/open_dir.lua` lists the directories of `projects.toml` in a
tofi window and opens the selected one in neovide:

```sh
lua ~/.aquamoon/scripts/util/open_dir.lua
```

It needs the `luafilesystem`, `tofi-lua` and `tinytoml` rocks (see
[Lua modules](#lua-modules)).

## Keybindings

| Key | Action |
|:----|:-------|
| `Super+Return` | neovide with the aquamoon2 configuration |
| `Super+A` / `Super+S` | neovide with the `tv` file/text channel |
| `Super+D` | application launcher (tofi-drun) |
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

> **Note**
> The keys of `toml/mappings.toml` are XKB keysym names, so the uppercase
> letters are the lowercase ones: `Super+D` is `Super+d`. `Shift` is a
> modifier of its own, `Super+S` and `Super+Shift+S` are different bindings.
>
> A river mapping runs a *riverctl* command, not a shell command: the
> launcher is bound to `lua-script util/launcher`, which river spawns.

## Differences from the aquamoon `main` branch

* the neovim configuration is the aquamoon2 one (`vim.pack`, `sweetie`, tv,
  oil/canola, ...) instead of the rocks.nvim based one
* no theme system: the river colours and the tofi/dunst colours are the
  `sweetie` ones and live in `toml/settings.toml`
* no menu hub, daemons, wallpaper, screen locker or weather widgets; the
  application launcher (`Super+D`) is the only tofi-drun menu
* `attach-mode` was replaced by `default-attach-mode` (river 0.3.x)
* bindings without modifiers use river's `None` modifier
* the neovim files stay in the repository root instead of `lua/`: the
  aquamoon2 layout has no `lua/` directory, so `init.lua` reads `settings.toml`
  with the `tinytoml` rock of `lua_modules/` instead of a vendored parser
