local theme = require("aquamoon/settings/theme")

local pick = function(picker_name, args)
	local choices = table.concat(args, "\n")
	local cmd = "echo '" .. choices .. "' | " .. picker_name
	local picker = io.popen(cmd)
	local result = ""
	if picker then
		result = picker:read("*a")
		picker:close()
	end
	return result
end

M = {
	with_tofi = function(args) return pick("tofi " .. table.concat(theme.tofi_style, " "), args) end,
	with_peco = function(args) return pick("peco ", args) end
}

if args then io.write(M.with_tofi(args)) end

return M
