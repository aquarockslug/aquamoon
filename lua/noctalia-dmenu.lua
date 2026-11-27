local M = {}

local is_nvim = type(vim) == "table" and type(vim.fn) == "table"

local function shell_escape(str)
    return "'" .. tostring(str):gsub("'", "'\\''") .. "'"
end

-- Backend 1: Neovim (no temp files, uses vim.fn.system with argument list)
local function run_nvim(lines, prompt)
    local cmd = { "noctalia", "dmenu" }
    if prompt and prompt ~= "" then
        table.insert(cmd, "-p")
        table.insert(cmd, prompt)
    end

    local stdin = table.concat(lines, "\n") .. "\n"
    local output = vim.fn.system(cmd, stdin)

    if vim.v.shell_error ~= 0 or not output or output == "" then
        return nil
    end

    return output
end

-- Backend 2: Standalone Lua (uses temp file + io.popen)
local function run_lua(lines, prompt)
    local tmpfile = os.tmpname()
    local f = io.open(tmpfile, "w")
    if not f then
        return nil
    end
    f:write(table.concat(lines, "\n") .. "\n")
    f:close()

    local cmd = "noctalia dmenu"
    if prompt and prompt ~= "" then
        cmd = cmd .. " -p " .. shell_escape(prompt)
    end
    cmd = cmd .. " < " .. shell_escape(tmpfile)

    local handle = io.popen(cmd, "r")
    if not handle then
        os.remove(tmpfile)
        return nil
    end

    local output = handle:read("*a")
    local ok = handle:close()
    os.remove(tmpfile)

    if not ok or not output or output == "" then
        return nil
    end

    return output
end

--- Prompts the user using `noctalia dmenu` (works in both Lua and Neovim).
---@param options table List of strings or tables (if `format` is provided)
---@param opts? table Optional settings: { prompt = string, format = function(item): string }
---@return any|nil selected The chosen item, or nil if cancelled
---@return number|nil index The 1-based index of the chosen item, or nil if cancelled
function M.select(options, opts)
    opts = opts or {}
    if not options or #options == 0 then
        return nil, nil
    end

    local lines = {}
    local lookup = {}
    for i, item in ipairs(options) do
        local label = opts.format and opts.format(item) or tostring(item)
        lines[i] = label
        if not lookup[label] then
            lookup[label] = { item = item, index = i }
        end
    end

    local output = is_nvim and run_nvim(lines, opts.prompt) or run_lua(lines, opts.prompt)
    if not output then
        return nil, nil
    end

    local chosen = output:gsub("\r?\n$", "")
    local match = lookup[chosen]

    if match then
        return match.item, match.index
    end

    return chosen, nil
end

--- Optional: Register as Neovim's default `vim.ui.select` provider
function M.setup_nvim_ui_select()
    if not is_nvim then
        return
    end

    vim.ui.select = function(items, opts, on_choice)
        opts = opts or {}
        local prompt = opts.prompt and opts.prompt:gsub(":%s*$", "") or "Select"
        local choice, idx = M.select(items, {
            prompt = prompt,
            format = opts.format_item,
        })
        on_choice(choice, idx)
    end
end

return setmetatable(M, {
    __call = function(_, ...)
        return M.select(...)
    end,
})
