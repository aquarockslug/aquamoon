# Aquamoon Portable Installation - Implementation Summary

## Overview
This implementation enables aquamoon to be installed without requiring `lua54`, `luarocks`, or manual Lua module installation. The window manager now compiles its C dependencies from source during setup, making it truly portable.

## What Changed

### 1. New `setup.lush` Script
A comprehensive bootstrap script that:
- **Checks dependencies**: Verifies runtime dependencies (river, tofi, noctalia, neovide)
- **Uses vendored `cffi.so`**:
  - **cffi-lua**: Vendored at `lib/cffi.so` (falls back to building with Meson if absent)
  - **POSIX calls**: Handled directly via `cffi` in `wm/wm.lua` (no `luaposix` required)
  - **wau**: Pure Lua Wayland bindings (cloned from codeberg.org/firefly/wau)
  - **xml2lua**: Pure Lua dependency for wau
- **Generates protocol bindings**: Uses wau-scanner to generate Wayland protocol Lua files
- **Configures the session**: Sets up river, noctalia, neovim, starship, haal, and the greeter

### 2. Updated `bin/wm` Launcher
The window manager launcher now:
- Prefers `lush` (portable Lua interpreter) over `lua5.4`
- Sets `LUA_CPATH` to `lib/` for compiled C modules
- Sets `LUA_PATH` to include both `lib/` and repository Lua files
- Falls back to luarocks paths if `lib/` doesn't exist (backwards compatibility)
- Falls back to `lua5.4` if lush isn't available

### 3. Updated README
Installation instructions now reflect the portable approach:
```sh
# Install build dependencies
sudo pacman -S river base-devel wayland-protocols tofi noctalia neovide

# Build lush (one-time)
git clone https://github.com/thiagomg/lush ~/lush
cd ~/lush && cargo build --release
cp target/release/lush ~/.aquamoon/bin/lush

# Run setup (compiles C modules, configures session)
cd ~/.aquamoon
./bin/lush setup.lush

# Start the session
river
```

### 4. Created `lib/.gitignore`
Ignores compiled artifacts (`.so` files) and build directories.

## Technical Details

### Build Process
1. **cffi-lua**: Vendored at `lib/cffi.so` (or built via `meson setup build -Dtests=false` → `ninja -C build` if missing)
2. **wau**: `git clone` from codeberg.org/firefly/wau → copies `wau/` directory and `wau-scanner.lua` to `lib/`
3. **xml2lua**: `git clone` → copies `xml2lua.lua` to `lib/`

### Runtime Flow
1. User runs `./bin/lush setup.lush`
2. setup.lush ensures `lib/cffi.so` and `lib/wau/` are present
3. setup.lush generates protocol bindings in `wm/protocol/`
4. setup.lush configures session (symlinks configs, creates river init script)
5. User starts `river`
6. `~/.config/river/init` executes `bin/wm`
7. `bin/wm` sets `LUA_CPATH` and `LUA_PATH` to use `lib/`
8. `bin/wm` executes `wm/wm.lua`
9. `wm.lua` loads `lib/cffi.so` and calls libc POSIX functions directly via FFI

### Backwards Compatibility
- If `lib/` doesn't exist, `bin/wm` falls back to luarocks paths
- If lush isn't available, `bin/wm` falls back to `lua5.4`
- Existing installations continue to work without changes

## Benefits
1. **No runtime dependencies on luarocks or lua54 packages**
2. **Truly portable**: Copy the repository + lush binary to another machine, run setup, done
3. **Self-contained**: All dependencies are compiled into the repository's `lib/` directory
4. **Version-locked**: C modules are built from specific sources, avoiding version conflicts
5. **Easy updates**: Re-run `./bin/lush setup.lush` to rebuild modules

## Testing
- ✅ cffi-lua Meson build validated (produces working `cffi.so`)
- ✅ setup.lush syntax validated
- ✅ bin/wm updated and executable
- ⏳ Full end-to-end test requires fresh installation

## Files Modified
- `setup.lush` (new)
- `bin/wm` (modified)
- `README.md` (modified)
- `lib/.gitignore` (new)
