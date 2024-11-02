--- download_files.lua: Download files from a specified GitHub repository directory.

--- Download files from a specified GitHub repository directory.
-- This script uses wget to download each file listed in the urls table.
-- @return nil: Returns nil upon completion.
local function download_files()
    local root_url = "https://raw.githubusercontent.com/unkokaeru/willow/main/source/"
    local filenames = {
        "main.lua",
        "logger.lua",
        "command_line_interface.lua",
        -- Add more filenames as needed
        -- TODO: Implement automatic file listing
    }

    for _, filename in ipairs(filenames) do
        local url = root_url .. filename
        os.execute("wget " .. url)
    end

    return nil
end

download_files()