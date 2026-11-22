# wm

Aquamoon's river window manager, forked from [tinyrwm](https://codeberg.org/river/tinyrwm). Written in Lua.

## Dependencies

- libwayland
- libxkbcommon

Everything else is vendored: `bin/lush` (Lua interpreter), `lib/cffi.so`, and the Lua modules in `lib/`.

## Layout

| Path | Purpose |
|:-----|:--------|
| `wm.lua` | window manager |
| `xkbcommon.lua` | keysym helper |
| `protocol/*.xml` | river protocol |
| `protocol/*.lua` | generated bindings |

## Tiling

Windows tile automatically in master/stack layout. First window gets the master area, rest stack on the right. Moving or resizing makes a window float.

Tune with `aquamoon.toml`:

```toml
[layout]
tiled = true
main-ratio = 0.66
gaps = 0
smart-gaps = true
```

Layout commands: `toggle-tiling`, `toggle-floating`, `increase-main-ratio`, `decrease-main-ratio`, `set-gaps N`, `toggle-smart-gaps`, `swap-view next/previous`.

## Running

```sh
river
```

`~/.config/river/init` execs `../bin/wm` which launches `wm.lua` with the right module paths.
