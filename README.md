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
| Shell | Noctalia (bar disabled) |
| Menus | Noctalia panels, opened with river keybindings |
| Notifications | Noctalia |
| Editor | Neovide + Neovim (aquamoon2 config) |

## Repository layout

The neovim configuration lives at the repository root, exactly like in
`aquamoon2`, so that `~/.config/nvim -> ~/.aquamoon` keeps pointing at it.
Everything else is grouped by topic:

```
init.lua               aquamoon2 neovim configuration (the entry point)
nvim-pack-lock.json    pinned plugin versions

lua/river/             river session, riverctl bindings, luatile layout
lua/sys/               settings loader, Noctalia notifications, tofi helpers
lua/util/              setup helper, paths, screenshot, launcher, picker

toml/settings.toml     neovim options, river/luatile options, tofi theme
toml/mappings.toml     river keybindings (including the Noctalia panels)
toml/startup.toml      session startup commands (noctalia, river-luatile)
toml/inputs.toml       pointer settings
toml/noctalia.toml     Noctalia shell configuration (bar disabled)
```

`init.lua` sits in the repository root and reads `toml/settings.toml` with the
`tinytoml` rock installed in `lua_modules/` (see [Lua modules](#lua-modules)).
The desktop scripts live in `lua/`, and `lua/util/paths.lua` adds that tree to
the Lua search path, for neovim and for the scripts alike.

## How it fits together

```
river (session start)
 └── ~/.config/river/init          -> lua/river/init.lua
      ├── lua/sys/settings.lua -> reads toml/*.toml
      ├── lua/river/river.lua   -> riverctl options, mappings, rules
      └── riverctl spawn           -> toml/startup.toml
           ├── noctalia --daemon   -> shell panels, notifications, OSD,
           │                          wallpaper, screenshots, lock screen
           └── river-luatile
                └── reads ~/.config/river-luatile/layout.lua
                     -> lua/river/layout.lua   (the luatile layout)

river (Super+D, Super+C, ...)
 └── noctalia msg panel-toggle ... -> opens a Noctalia panel on demand

river (Super+Return)
 └── env NVIM_APPNAME=nvim neovide
      └── nvim -> ~/.config/nvim -> ~/.aquamoon/init.lua (aquamoon2 config)
```

Noctalia's own bar is disabled in `toml/noctalia.toml` (`[bar.main]
enabled = false`). Its panels are configured as floating panels, because there
is no bar for them to attach to, and every panel is reached with a keybinding.

`lua/river/layout.lua` is the layout generator river-luatile executes. It
is also the script that receives the `riverctl send-layout-cmd luatile ...`
commands used by the layout menu (`Super+O`) and by `Super+Shift+H`/`Super+Shift+L`.

## Setup

```sh
lua ~/.aquamoon/lua/util/setup.lua
```

The helper checks the dependencies (the system commands and the Lua modules
listed below) and creates:

| Path | Purpose |
|:-----|:--------|
| `~/.config/river/init` | bash wrapper running `lua/river/init.lua` |
| `~/.config/river-luatile` | symlink to `lua/river` (river-luatile reads `layout.lua` from there) |
| `~/.config/noctalia/config.toml` | symlink to `toml/noctalia.toml` (the Noctalia shell configuration) |

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
| `luafilesystem` | `lua/util/open_dir.lua` (directory listing) |
| `tofi-lua` | `lua/util/open_dir.lua` (the project picker) |

```sh
luarocks --tree ~/.aquamoon/lua_modules install tinytoml
luarocks --tree ~/.aquamoon/lua_modules install luafilesystem
luarocks --tree ~/.aquamoon/lua_modules install tofi-lua
```

`lua/util/paths.lua` adds the tree to the Lua search path and every script
loads it itself, so they can be run from anywhere. neovim runs LuaJIT (5.1)
while the scripts run the system Lua (5.5); `tinytoml` is pure Lua, so the one
install serves both, while the C modules (`luafilesystem`, `tofi-lua`) are
built for the system Lua and only used by the scripts.

### Project picker

`lua/util/open_dir.lua` lists the directories of `projects.toml` in a
tofi window and opens the selected one in neovide:

```sh
lua ~/.aquamoon/lua/util/open_dir.lua
```

It needs the `luafilesystem`, `tofi-lua` and `tinytoml` rocks (see
[Lua modules](#lua-modules)).

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
| `Super+Shift+S` | screenshot (slurp + grim) |
| `Super+B` / `Super+N` | volume down / up |
| `Super+V` / `Super+M` | brightness down / up |
| `XF86Audio*` / `XF86MonBrightness*` | volume, mute and brightness keys |
| `Super+BTN_LEFT` / `Super+BTN_RIGHT` | move / resize view |

> **Note**
> The keys of `toml/mappings.toml` are XKB keysym names, so the uppercase
> letters are the lowercase ones: `Super+D` is `Super+d`. `Shift` is a
> modifier of its own, `Super+S` and `Super+Shift+S` are different bindings.
>
> A river mapping runs a *riverctl* command, not a shell command: the Noctalia
> panels are bound to `spawn "noctalia msg ..."`, which river spawns. Noctalia
> has no bar; its panels float in the center of the focused output and the
> same key closes them again (`panel-toggle`).
>
> The brightness keys target `eDP-1`, the internal panel pinned in
> `toml/noctalia.toml`, so they keep working while an external monitor has
> focus. Inside the launcher, `/pan` lists every Noctalia panel and control
> center tab, `/win` searches windows, `/wall` searches wallpapers, `/emo`
> copies emoji and `/calc` evaluates expressions.

## Differences from the aquamoon `main` branch

* the neovim configuration is the aquamoon2 one (`vim.pack`, `sweetie`, tv,
  oil/canola, ...) instead of the rocks.nvim based one
* [Noctalia](https://noctalia.dev) is the desktop shell: launcher, control
  center, clipboard, wallpaper, notifications, OSD and lock screen. Its bar is
  disabled and every panel is opened with a river keybinding (see
  [Keybindings](#keybindings))
* no theme system for river and tofi: the river border colours and the tofi
  colours are the `sweetie` ones and live in `toml/settings.toml`; Noctalia
  manages its own palette in `toml/noctalia.toml`
* `attach-mode` was replaced by `default-attach-mode` (river 0.3.x)
* bindings without modifiers use river's `None` modifier
* the neovim files stay in the repository root instead of a dedicated `lua/`
  tree: `init.lua` reads `toml/settings.toml` with the `tinytoml` rock of
  `lua_modules/` instead of a vendored parser (the `lua/` directory holds the
  desktop scripts, not the neovim modules)
