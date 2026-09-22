-- settings.lua - minimal TOML parser for the aquamoon2 settings.toml.
--
-- open_dir.lua reads this file with `toml_edit`, but that rock is a C module
-- built for Lua 5.5 and nvim's LuaJIT (5.1) cannot load it
-- (`undefined symbol: lua_rotate`), so we keep a self-contained parser here.
-- It produces the same shape as `toml_edit.parse_as_tbl`: top-level keys and
-- [section] tables such as settings.options and settings.tofi.
--
-- Supported TOML: comments, bare/quoted/dotted keys, [table] headers,
-- basic and literal strings, integers, floats (incl. inf/nan), booleans,
-- arrays, inline tables, trailing commas. Anything else fails loudly with a
-- "settings.toml:<line>:" error.

local settings = {}

local function fail(line, msg, ...)
	error(("settings.toml:%d: %s"):format(line, msg:format(...)), 0)
end

-- Parser state
local P = {}

local function eof()
	return P.pos > P.len
end

local function peek()
	return P.src:sub(P.pos, P.pos)
end

-- Skip spaces, tabs, newlines and # comments
local function skip_ws()
	while P.pos <= P.len do
		local c = P.src:sub(P.pos, P.pos)
		if c == "\n" then
			P.line = P.line + 1
			P.pos = P.pos + 1
		elseif c == " " or c == "\t" or c == "\r" then
			P.pos = P.pos + 1
		elseif c == "#" then
			local nl = P.src:find("\n", P.pos, true)
			P.pos = nl and nl + 1 or P.len + 1
			P.line = P.line + 1
		else
			break
		end
	end
end

local function read_bare_key()
	local from = P.pos
	while P.pos <= P.len do
		local c = P.src:sub(P.pos, P.pos)
		if c:match("[%w_%-]") then
			P.pos = P.pos + 1
		else
			break
		end
	end
	return P.src:sub(from, P.pos - 1)
end

local function read_basic_string()
	P.pos = P.pos + 1 -- opening quote
	local chunks = {}
	while true do
		local c = P.src:sub(P.pos, P.pos)
		if P.pos > P.len or c == "\n" then
			fail(P.line, "unterminated string")
		end
		if c == '"' then
			P.pos = P.pos + 1
			break
		elseif c == "\\" then
			P.pos = P.pos + 1
			local e = P.src:sub(P.pos, P.pos)
			P.pos = P.pos + 1
			if e == "b" then
				chunks[#chunks + 1] = "\b"
			elseif e == "t" then
				chunks[#chunks + 1] = "\t"
			elseif e == "n" then
				chunks[#chunks + 1] = "\n"
			elseif e == "f" then
				chunks[#chunks + 1] = "\f"
			elseif e == "r" then
				chunks[#chunks + 1] = "\r"
			elseif e == '"' then
				chunks[#chunks + 1] = '"'
			elseif e == "\\" then
				chunks[#chunks + 1] = "\\"
			elseif e == "u" or e == "U" then
				local n = e == "u" and 4 or 8
				local hex = P.src:sub(P.pos, P.pos + n - 1)
				if #hex < n or not hex:match("^[%x]+$") then
					fail(P.line, "invalid \\%s escape", e)
				end
				P.pos = P.pos + n
				local cp = tonumber(hex, 16)
				if cp <= 0x7F then
					chunks[#chunks + 1] = string.char(cp)
				else
					local u = utf8 and utf8.char
					if not u then
						fail(P.line, "\\%s escape not supported by this Lua build", e)
					end
					chunks[#chunks + 1] = u(cp)
				end
			else
				fail(P.line, "invalid escape '\\%s'", e)
			end
		else
			chunks[#chunks + 1] = c
			P.pos = P.pos + 1
		end
	end
	return table.concat(chunks)
end

local function read_literal_string()
	P.pos = P.pos + 1 -- opening quote
	local from = P.pos
	while true do
		local c = P.src:sub(P.pos, P.pos)
		if P.pos > P.len or c == "\n" then
			fail(P.line, "unterminated string")
		end
		if c == "'" then
			local s = P.src:sub(from, P.pos - 1)
			P.pos = P.pos + 1
			return s
		end
		P.pos = P.pos + 1
	end
end

local function read_number()
	local i = P.pos
	local sign = ""
	local c = P.src:sub(i, i)
	if c == "+" or c == "-" then
		sign = c
		i = i + 1
		c = P.src:sub(i, i)
	end

	-- inf / nan
	if c == "i" or c == "n" then
		local w = P.src:match("^inf", i) or P.src:match("^nan", i)
		if not w then
			fail(P.line, "invalid number")
		end
		P.pos = i + #w
		if w == "inf" then
			return sign == "-" and -math.huge or math.huge
		end
		return 0 / 0 -- nan
	end

	if P.src:match("^0[xob]", i) then
		fail(P.line, "hex/octal/binary integers are not supported by the settings parser")
	end

	local int = P.src:match("^%d[%d_]*", i)
	if not int then
		fail(P.line, "invalid number")
	end
	i = i + #int

	local frac = ""
	local frac_p = P.src:match("^%.%d[%d_]*", i)
	if frac_p then
		frac = "." .. frac_p:sub(2):gsub("_", "")
		i = i + #frac_p
	end

	local exp = ""
	local exp_p = P.src:match("^[eE][%+%-]?%d[%d_]*", i)
	if exp_p then
		exp = exp_p:gsub("_", "")
		i = i + #exp_p
	end

	P.pos = i
	local n = tonumber(sign .. int:gsub("_", "") .. frac .. exp)
	if not n then
		fail(P.line, "invalid number")
	end
	return n
end

local function read_bool()
	local w = P.src:match("^true", P.pos) or P.src:match("^false", P.pos)
	if not w then
		fail(P.line, "invalid value")
	end
	P.pos = P.pos + #w
	local c = P.src:sub(P.pos, P.pos)
	if c:match("[%w_]") then
		fail(P.line, "invalid value '%s'", w .. c)
	end
	return w == "true"
end

local function read_key_segment()
	local c = peek()
	if c == '"' then
		return read_basic_string()
	elseif c == "'" then
		return read_literal_string()
	else
		local k = read_bare_key()
		if k == "" then
			fail(P.line, "expected a key")
		end
		return k
	end
end

local function parse_key_path()
	local keys = { read_key_segment() }
	while true do
		skip_ws()
		if peek() == "." then
			P.pos = P.pos + 1
			keys[#keys + 1] = read_key_segment()
		else
			break
		end
	end
	return keys
end

local parse_value

local function parse_array()
	P.pos = P.pos + 1 -- '['
	skip_ws()
	local t = {}
	if peek() == "]" then
		P.pos = P.pos + 1
		return t
	end
	while true do
		t[#t + 1] = parse_value()
		skip_ws()
		local c = peek()
		if c == "," then
			P.pos = P.pos + 1
			skip_ws()
			if peek() == "]" then -- trailing comma
				P.pos = P.pos + 1
				break
			end
		elseif c == "]" then
			P.pos = P.pos + 1
			break
		else
			fail(P.line, "expected ',' or ']' in array")
		end
	end
	return t
end

local function parse_inline_table()
	P.pos = P.pos + 1 -- '{'
	skip_ws()
	local t = {}
	if peek() == "}" then
		P.pos = P.pos + 1
		return t
	end
	while true do
		local keys = parse_key_path()
		skip_ws()
		if peek() ~= "=" then
			fail(P.line, "expected '=' in inline table")
		end
		P.pos = P.pos + 1
		skip_ws()
		local v = parse_value()
		local target = t
		for i = 1, #keys - 1 do
			local seg = keys[i]
			local next_t = target[seg]
			if type(next_t) ~= "table" then
				next_t = {}
			end
			target[seg] = next_t
			target = next_t
		end
		target[keys[#keys]] = v
		skip_ws()
		local c = peek()
		if c == "," then
			P.pos = P.pos + 1
			skip_ws()
			if peek() == "}" then -- trailing comma
				P.pos = P.pos + 1
				break
			end
		elseif c == "}" then
			P.pos = P.pos + 1
			break
		else
			fail(P.line, "expected ',' or '}' in inline table")
		end
	end
	return t
end

parse_value = function()
	local c = peek()
	if c == '"' then
		return read_basic_string()
	elseif c == "'" then
		return read_literal_string()
	elseif c == "[" then
		return parse_array()
	elseif c == "{" then
		return parse_inline_table()
	elseif c == "t" or c == "f" then
		return read_bool()
	elseif c:match("[%d%+%-in]") then
		return read_number()
	else
		fail(P.line, "unexpected character %s in value",
			c == "" and "<end of file>" or string.format("%q", c))
	end
end

--- Parse TOML text into a plain Lua table.
local function parse(src)
	P = { src = src, pos = 1, line = 1, len = #src }
	local root = {}
	local cur = root
	skip_ws()
	while not eof() do
		if peek() == "[" then
			-- [table] or [table.sub] header
			P.pos = P.pos + 1
			local keys = parse_key_path()
			skip_ws()
			if peek() ~= "]" then
				fail(P.line, "expected ']' in table header")
			end
			P.pos = P.pos + 1
			skip_ws() -- rest of the line may only be whitespace/comment

			cur = root
			for i = 1, #keys do
				local k = keys[i]
				local existing = cur[k]
				if existing ~= nil and type(existing) ~= "table" then
					fail(P.line, "key '%s' conflicts with a value", k)
				end
				if existing == nil then
					existing = {}
					cur[k] = existing
				end
				cur = existing
			end
		else
			-- key = value (keys may be `a.b.c`)
			local keys = parse_key_path()
			skip_ws()
			if peek() ~= "=" then
				fail(P.line, "expected '=' after key '%s'", table.concat(keys, "."))
			end
			P.pos = P.pos + 1
			skip_ws()
			local v = parse_value()

			local target = cur
			for i = 1, #keys - 1 do
				local k = keys[i]
				local existing = target[k]
				if existing ~= nil and type(existing) ~= "table" then
					fail(P.line, "key '%s' conflicts with a value", k)
				end
				if existing == nil then
					existing = {}
					target[k] = existing
				end
				target = existing
			end
			local last = keys[#keys]
			if target[last] ~= nil then
				fail(P.line, "duplicate key '%s'", table.concat(keys, "."))
			end
			target[last] = v

			skip_ws() -- trailing whitespace/comment/newline
		end
	end
	return root
end

settings.parse = parse
return settings