--- download_files.lua: Download files from a specified GitHub repository directory.

--- Download files from a specified GitHub repository directory.
-- This script generates a shell script to download each file listed in the filenames table.
-- @return nil: Returns nil upon completion.

local function download_files()
    local root_url = "https://raw.githubusercontent.com/unkokaeru/willow/main/source/"
    local filenames = {
        "main.lua",
        "logger.lua",
        "command_line_interface.lua",
        -- Add more filenames as needed
        -- TODO: Implement automatic file listing
        -- Issue URL: https://github.com/unkokaeru/willow/issues/1
    }

    -- Create a shell script to download the files
    local script_name = "download_files.sh"
    local file = io.open(script_name, "w")

    if not file then
        print("Error: Unable to create script file.")
        return nil
    end

    -- Write the wget commands to the shell script
    for _, filename in ipairs(filenames) do
        local url = root_url .. filename
        file:write("wget " .. url .. "\n")
    end

    file:close()
    print("Download script created: " .. script_name)
    print("Run the script using: sh " .. script_name)

    return nil
end

download_files()