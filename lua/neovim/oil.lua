local M = {}

local uv = vim.uv or vim.loop
local columns = require("oil.columns")
local constants = require("oil.constants")
local oil = require("oil")

local FIELD_NAME = constants.FIELD_NAME
local FIELD_META = constants.FIELD_META
local FIELD_TYPE = constants.FIELD_TYPE

local CACHE_TTL = 10
local cache = {}

local function format_size(size)
	if size >= 1e9 then
		return string.format("%.1fG", size / 1e9)
	elseif size >= 1e6 then
		return string.format("%.1fM", size / 1e6)
	elseif size >= 1e3 then
		return string.format("%.1fk", size / 1e3)
	else
		return string.format("%d", size)
	end
end

local function sum_dir(path)
	local total = 0

	local function walk(dir)
		local handle = uv.fs_scandir(dir)
		if not handle then
			return
		end
		while true do
			local name, typ = uv.fs_scandir_next(handle)
			if not name then
				break
			end
			local child = vim.fs.joinpath(dir, name)
			if not typ then
				local stat = uv.fs_lstat(child)
				typ = stat and stat.type
			end
			if typ == "directory" then
				walk(child)
			else
				-- Do not follow symlinks; count the link itself.
				local stat = uv.fs_lstat(child)
				if stat and stat.size then
					total = total + stat.size
				end
			end
		end
	end

	walk(path)
	return total
end

local function cached_dir_size(path)
	local now = os.time()
	local entry = cache[path]
	if entry and now - entry.time < CACHE_TTL then
		return entry.size
	end
	local size = sum_dir(path)
	cache[path] = { time = now, size = size }
	return size
end

function M.setup()
	columns.register("total_size", {
		render = function(entry, _, bufnr)
			local cwd = oil.get_current_dir(bufnr)
			if not cwd then
				return columns.EMPTY
			end

			local path = vim.fs.joinpath(cwd, entry[FIELD_NAME])
			local meta = entry[FIELD_META]
			local stat = meta and meta.stat
			local size

			if entry[FIELD_TYPE] == "directory" then
				size = cached_dir_size(path)
			else
				size = stat and stat.size
				if not size then
					stat = uv.fs_lstat(path)
					size = stat and stat.size
				end
			end

			if not size then
				return columns.EMPTY
			end
			return format_size(size)
		end,
		parse = function(line)
			return line:match("^(%S+)%s+(.*)$")
		end,
	})

	vim.api.nvim_create_autocmd("User", {
		pattern = { "OilMutationComplete", "OilReadPost" },
		callback = function()
			cache = {}
		end,
	})
end

return M
