--- Utility functions for working with files.
--- @module "utilities.file_utilities"

local logging = require("modules.logging")

local logger = logging.get_logger("file_utilities", "file_utilities.log")

local file_utilities = {}


--- Deletes a file.
--- @param file_path string The path to the file to delete.
--- @return boolean success Whether the file was deleted successfully.
function file_utilities.delete_file(file_path)
    logger.trace("Deleting file: " .. file_path)
    return fs.remove(file_path)
end


--- Writes a string to a file.
--- @param file_path string The path to the file to save.
--- @param contents string The contents to save to the file.
--- @return boolean success Whether the file was saved successfully.
function file_utilities.write_file(file_path, contents)
    logger.trace("Writing file: " .. file_path)
    local file = fs.open(file_path, "w")

    if not file then
        logger.error("Error writing file: " .. file_path)
        return false
    end

    file.write(contents)
    file.close()
    logger.trace("File written: " .. file_path)

    return true
end


--- Reads a file and returns the contents.
--- @param file_path string The path to the file to read.
--- @return table|nil contents The contents of the file, or nil if the file could not be read.
function file_utilities.read_json(file_path)
    local file = fs.open(file_path, "r")
    logger.trace("Reading JSON file: " .. file_path)
    if not file then
        logger.error("Error reading file: " .. file_path)
        return nil
    end

    local contents = textutils.unserialiseJSON(file.readAll())
    file.close()
    logger.trace("JSON file read: " .. file_path)
    return contents
end


--- Writes a table to a file as JSON.
--- @param file_path string The path to the file to write to.
--- @param contents table The contents to write to the file.
--- @return boolean success Whether the file was written successfully.
function file_utilities.write_json(file_path, contents)
    local file = fs.open(file_path, "w")
    logger.trace("Writing JSON file: " .. file_path)
    if not file then
        logger.error("Error writing file: " .. file_path)
        return false
    end

    file.write(textutils.serialiseJSON(contents))
    file.close()
    logger.trace("JSON file written: " .. file_path)
    return true
end


return file_utilities