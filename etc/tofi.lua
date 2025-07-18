-- exec $(tofi-drun --font="IosevkaTermSlab NFM" --width="33%" --outline-width=0 --border-width=1 --prompt-text="󰈿_"
-- --selection-color="#FFFFFF" --text-color="#50FA7B" --border-color="#50FA7B" --background-color="#272E33"

S = require "settings"

cmd = "tofi-drun"

for i, arg in ipairs(S.theme.tofi_style) do
	cmd = cmd .. " " .. arg
end
print(cmd)
os.execute(cmd .. " &")
