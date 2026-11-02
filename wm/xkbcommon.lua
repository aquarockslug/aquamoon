-- SPDX-FileCopyrightText: © 2026 FireFly
-- SPDX-License-Identifier: 0BSD

local ffi = require("cffi")

local M = {}

local raw = ffi.load("xkbcommon")

ffi.cdef [[
    typedef uint32_t xkb_keysym_t;

    enum xkb_keysym_flags {
        XKB_KEYSYM_NO_FLAGS = 0,
        XKB_KEYSYM_CASE_INSENSITIVE = (1 << 0)
    };

    xkb_keysym_t
    xkb_keysym_from_name(const char *name, enum xkb_keysym_flags flags);

    xkb_keysym_t
    xkb_keysym_to_lower(xkb_keysym_t ks);
]]

function M.keysym(name, flags)
    local sym = raw.xkb_keysym_from_name(name, flags or 0)
    if sym == 0 and flags == nil then
        sym = raw.xkb_keysym_from_name(name, 1) -- XKB_KEYSYM_CASE_INSENSITIVE
    end
    return raw.xkb_keysym_to_lower(sym)
end

return M
