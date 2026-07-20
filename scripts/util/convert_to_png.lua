-- Convert all images to PNG, resize to 1080p, and remove originals

local dir = arg[1] or os.getenv("PWD") or "."

local function convert_and_remove(ext)
    local handle = io.popen(string.format("find %s -name '*.%s'", dir, ext))
    if handle then
        for file in handle:lines() do
            os.execute(string.format("mogrify -format png '%s'", file))
            os.execute(string.format("rm '%s'", file))
        end
        handle:close()
    end
end

convert_and_remove("jpg")
convert_and_remove("jpeg")
convert_and_remove("webp")
