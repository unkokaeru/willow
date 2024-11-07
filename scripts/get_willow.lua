--- Installs the willow package.
--- @file get_willow.lua
--- @date 2024-11-07
--- @version 0.1.0
--- @license MIT
--- @author William Fayers

local shell = require("cc.shell")

--- Constants
-- The command to download a file.
local GET_COMMAND = "wget"
-- The command to make a directory.
local MAKE_DIRECTORY_COMMAND = "mkdir"
-- The willow repository.
local WILLOW_SOURCE_REPOSITORY = "https://raw.githubusercontent.com/unkokaeru/willow/main/source/"
-- The directory to save the willow files to.
local WILLOW_DIRECTORY = "/usr/lib/willow/"
-- The structure of the willow files.
local WILLOW_FILE_STRUCTURE = {
    config = {name = "config", files = {
        "constants",
        "paths"
    }},
    modules = {name = "modules", files = {
        "command_line_interface",
        "logging",
        "package_manager"
    }},
    utilities = {name = "utilities", files = {
        "print_utilities",
        "network_utilities",
        "print_utilities",
        "string_utilities"
    }},
    main = {name = "main", files = {}}
}
-- The file extension.
local FILE_EXTENSION = ".lua"

--- Downloads a file from the willow repository.
--- @param willow_file string The file to download.
--- @param downloaded_file_name string|nil The name to save the file as, defaults willow file name.
local function download_willow_file(willow_file, downloaded_file_name)
    if not downloaded_file_name then
        downloaded_file_name = willow_file
    end

    shell.run(
        GET_COMMAND,
        WILLOW_SOURCE_REPOSITORY ..
        willow_file .. FILE_EXTENSION,
        downloaded_file_name .. FILE_EXTENSION
    )
end


--- Downloads all willow files.
local function main()
    -- Create the willow directory.
    shell.run(MAKE_DIRECTORY_COMMAND, WILLOW_DIRECTORY)

    -- Download all willow files.
    for _, item in pairs(WILLOW_FILE_STRUCTURE) do
        if not item.files then
            download_willow_file(WILLOW_DIRECTORY .. item.name)

            return 0
        end

        -- Create the directory.
        shell.run(MAKE_DIRECTORY_COMMAND, WILLOW_DIRECTORY .. item.name)

        -- Download all files within the directory.
        for _, file in pairs(item.files) do
            download_willow_file(WILLOW_DIRECTORY .. item.name .. "/" .. file)
        end
    end

    return 0
end


return main()