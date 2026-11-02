-- SPDX-FileCopyrightText: © 2026 FireFly
-- SPDX-License-Identifier: 0BSD

package = "wm"
version = "dev-1"
rockspec_format = "3.0"

-- Forked from tinyrwm; the source URL documents the upstream project.
source = {
    url = "git+https://codeberg.org/river/tinyrwm",
}

description = {
    summary = "Aquamoon window manager for river (fork of tinyrwm)",
    homepage = "https://codeberg.org/river/tinyrwm",
    license = "0BSD",
}

dependencies = {
    "lua == 5.4",
    "cffi-lua >= 0.2.4",
    "firefly/wau",
    "luaposix",
}

external_dependencies = {
    -- runtime dependencies: ensure these are in your LD_LIBRARY_PATH
 -- XKBCOMMON = { library = "libxkbcommon.so" },
 -- WAYLAND = { library = "libwayland-client.so" },
}

build = {
    type = "command",
    build_command = [[
        for f in protocol/*.xml; do
            wau-scanner <$f >${f%%.xml}.lua
        done
    ]],
    install_command = [[
        # mimic build.type == "builtin" behaviour
        install -Dm644 xkbcommon.lua $(LUADIR)/wm/xkbcommon.lua
        install -Dm644 -t $(LUADIR)/wm/protocol protocol/*.lua
        install -Dm755 wm.lua $(BINDIR)/wm
    ]],
}
