# AQUAMOON2-RIVER

An [Arch Linux](https://archlinux.org) desktop environment configured with Lua,
running on river 0.5, the newest non-monolithic
[river](https://codeberg.org/river/river) compositor, with `wm` as the window
manager.

The vendored `wm/wm.lua` started by the session is a small floating window
manager forked from [tinyrwm](https://codeberg.org/river/tinyrwm). Aquamoon
adds TOML-driven keybindings, tags, borders, startup commands, window rules and
click-to-focus on top of the upstream tinyrwm implementation.

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
`toml/aquamoon.toml`. `wm/wm.lua` reads that file directly at startup, so
changes can be tested by restarting the session.

Run `lua lua/aquamoon.lua setup` once to generate the protocol bindings and
install the session wrapper:

```sh
lua lua/aquamoon.lua setup
river
```

The session runs the vendored `wm` directly; there is no install step. See
[Customising the window manager](#customising-the-window-manager).

Only the options implemented by `wm` are used: `border-width`,
`border-color-focused`, `border-color-unfocused`, `focus-follows-cursor`
(`disabled` or `normal`), `default-attach-mode` (`top` or `bottom`) and
`set-repeat` (`[rate, delay]`, repeats per second and initial delay in
milliseconds). Window rules currently support `ssd` (server-side decorations).

The `[inputs.*]` tables are applied through the river input protocols.
`device` accepts either the libinput name (for example
`PIXA200B:00 093A:200B Touchpad`) or the river-classic
`pointer-vendor-product-name` identifier. Supported settings are `tap`
(`enabled`/`disabled`, touchpads only) and `pointer-accel` (clamped to the
libinput range `-1` to `1`). Bindings with `opt = "repeat"` keep firing while
the key is held.

`wm` binds `river_layer_shell_v1`, so layer-shell clients such as Noctalia
panels, the launcher and notifications can map surfaces. It also marks the
first output as the default for layer surfaces and yields keyboard focus while
an exclusive layer surface is open.

## Greeter

`toml/noctalia-greeter.toml` configures the greetd login screen. It matches the
Aquamoon palette and wallpaper, defaults to the `River` session and the `aqua`
user, and uses the same font and clock formats as the shell.

`lua lua/aquamoon.lua setup` installs it as
`/var/lib/noctalia-greeter/greeter.toml` (via `sudo`), copies the wallpaper to
`/var/lib/noctalia-greeter/wallpaper.png`, and prints the command to restart
greetd. The greeter runs as the unprivileged greetd user, so the files are
copied instead of symlinked into `~/.aquamoon`.

## Customising the window manager

The session does not use an installed copy of `wm`. `bin/wm` sets up the Lua
5.4 module paths and runs `wm/wm.lua` from this repository, and
`~/.config/river/init` execs that launcher. Edit the source, restart river, and
the new code is in use.

| Path | Purpose |
|:-----|:--------|
| `bin/wm` | launcher: LuaRocks paths + `lua5.4 wm/wm.lua` |
| `wm/wm.lua` | window manager implementation |
| `wm/xkbcommon.lua` | keysym helper |
| `wm/protocol/*.xml` | river protocol descriptions |
| `wm/protocol/*.lua` | bindings generated by `wau-scanner` |
| `toml/aquamoon.toml` | bindings, tags, borders and startup commands |
| `lua/tinytoml.lua` | TOML parser used at startup |

`lua lua/aquamoon.lua setup` regenerates the protocol bindings after the XML
files change. To regenerate a single protocol by hand:

```sh
eval "$(luarocks --lua-version=5.4 path)"
wau-scanner < wm/protocol/river-window-management-v1.xml \
    > wm/protocol/river-window-management-v1.lua
```

Window-manager behaviour belongs in `wm/wm.lua`; user-facing configuration
belongs in `toml/aquamoon.toml`, so personal keybindings do not need to touch
the implementation.

## Theme

Noctalia generates the Neovim palette from the active theme (`toml/nvim-template.lua`), and `init.lua` applies it with `mini.base16`. The shell palette and font are configured in `toml/noctalia.toml`.
