-- Lua api for Tofi

-- Usage example:
-- local my_opener = require("tofi").options({})
-- my_opener.choices({}).open()

opener = function(choi, opts)
	return {
		-- build and execute a command using this opener's parameters
		open = function()
			cmd = "tofi"

			-- create this with opts table
			local tofi_style = {
				"--font=" .. theme.active_font.path,
				"--font-size=" .. theme.active_font.size,
				"--width=33%",
				"--height=66%",
				"--drun-launch=true",
				"--outline-width=0",
				"--border-width=" .. theme.border_width,
				"--prompt-text='󰈿 '",
				"--selection-color=#" .. theme.fg2,
				"--text-color=#" .. theme.fg,
				"--border-color=#" .. theme.bg2,
				"--background-color=#" .. theme.bg,
				"--text-cursor=true",
				"--result-spacing=9",
				"--anchor=bottom",
				"--margin-bottom=10",
				-- "--margin-bottom=26",
				-- "--margin-left=" .. theme.border_width + 8,
			}

			for i, arg in ipairs(theme.tofi_style) do
				cmd = cmd .. " " .. arg
			end
		end,


		-- these functions return new openers

		-- get info about the opener
		info = function()
			return { choices = choi, options = opts }
		end,
		-- return a new opener with the new choices
		choices = function(new_choi)
			return opener(new_choi, opts)
		end,
		-- return a new opener with the new options
		options = function(new_opts)
			-- TODO convert new_opts from { option = "value" } into "--option=value"
			return opener(choi, new_opts)
		end,
	}
end

return opener({}, {})
