local M = {}

local function is_list(tbl)
	local count = 0
	for k in pairs(tbl) do
		if type(k) ~= "number" then
			return false
		end
		count = count + 1
	end
	return count > 0
end

local function merge(dst, src)
	for k, v in pairs(src) do
		if type(v) == "table" and type(dst[k]) == "table" and not is_list(v) and not is_list(dst[k]) then
			merge(dst[k], v)
		else
			dst[k] = v
		end
	end
	return dst
end

local function resolve_path(base_dir, target)
	if target:sub(1, 2) == "~/" then
		return (os.getenv("HOME") or "") .. target:sub(2)
	end
	if target:sub(1, 1) == "/" then
		return target
	end
	return base_dir .. "/" .. target
end

function M.parse(path, visited)
	visited = visited or {}
	if visited[path] then
		return {}
	end
	visited[path] = true

	local tinytoml = require("tinytoml")
	local data = tinytoml.parse(path)
	if type(data) ~= "table" then
		return {}
	end

	local include = data.include
	data.include = nil
	if type(include) == "table" and type(include.files) == "table" then
		local base_dir = path:match("^(.*)/[^/]+$") or "."
		local merged = {}
		for _, file in ipairs(include.files) do
			if type(file) == "string" then
				local child_path = resolve_path(base_dir, file)
				merge(merged, M.parse(child_path, visited))
			end
		end
		data = merge(merged, data)
	end

	return data
end

function M.load(file)
	local path = vim.fn.stdpath("config") .. "/toml/" .. file
	local ok, result = pcall(M.parse, path)
	if not ok then
		vim.notify(file .. ": " .. tostring(result), vim.log.levels.WARN)
	end
	return ok and result or {}
end

return M
