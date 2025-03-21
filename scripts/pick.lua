
function pick(...)
	local choices = table.concat(..., "\n")
	local cmd = "echo '" .. choices .. "' | peco"
	local picker = io.popen(cmd)
	local result = picker:read("*a")
	picker:close()
	return result
end

print(pick(args))
