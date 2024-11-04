local paths = require("config.paths")

local function loadDatabase()
    local f = fs.open(paths.DATABASE_PATH, "r")
    if f then
        local db = textutils.unserialiseJSON(f.readAll())
        f.close()
        return db
    end
    return { packages = {} }
end

local function saveDatabase(db)
    local f = fs.open(paths.DATABASE_PATH, "w")
    f.write(textutils.serialiseJSON(db))
    f.close()
end

local function deleteFile(filePath)
    if fs.exists(filePath) then
        fs.delete(filePath)
        print("Deleted file: " .. filePath)
    else
        print("File not found: " .. filePath)
    end
end

return {
    loadDatabase = loadDatabase,
    saveDatabase = saveDatabase,
    deleteFile = deleteFile
}