local fileUtils = require("utilities.file_utilities")
local networkUtils = require("utilities.network_utilities")
local constants = require("config.constants")

local manifest = networkUtils.getLatestManifest()

local function showAvailablePackages()
    print("Available packages:")
    for packageName, packageData in pairs(manifest["packages"]) do
        print(" - " .. packageName .. " (" .. packageData["version"] .. ")")
    end
end

local function showInstalledPackages()
    local db = fileUtils.loadDatabase()
    print("Installed packages:")
    for packageName, _ in pairs(db["packages"]) do
        print(" - " .. packageName)
    end
end

local function downloadPackage(packageName)
    local db = fileUtils.loadDatabase()
    local packageData = manifest["packages"][packageName]

    if not packageData then
        print("Package '" .. packageName .. "' not found.")
        showAvailablePackages()
        return
    end

    print("Downloading " .. packageName .. " (" .. packageData["version"] .. ")...")

    -- Download files
    for _, file in ipairs(packageData["files"]) do
        local sourceUrl = file[1]
        local downloadPath = file[2]
        networkUtils.downloadFile(sourceUrl, downloadPath)
    end

    -- Update database
    db["packages"][packageName] = {
        version = packageData["version"],
        type = packageData["type"],
        files = packageData["files"]
    }
    fileUtils.saveDatabase(db)
    print("Downloaded " .. packageName)
end

local function uninstallPackage(packageName)
    local db = fileUtils.loadDatabase()
    local packageData = db["packages"][packageName]

    if packageData then
        print("Uninstalling " .. packageName .. "...")
        for _, file in ipairs(packageData["files"]) do
            fileUtils.deleteFile(file[2])
        end
        db["packages"][packageName] = nil
        fileUtils.saveDatabase(db)
        print("Uninstalled " .. packageName)
    else
        print("Package '" .. packageName .. "' not found.")
    end
end

local function updatePrograms()
    local db = fileUtils.loadDatabase()
    for packageName, packageData in pairs(db["packages"]) do
        if packageData["type"] == "program" then
            downloadPackage(packageName)
        end
    end
end

return {
    showAvailablePackages = showAvailablePackages,
    showInstalledPackages = showInstalledPackages,
    downloadPackage = downloadPackage,
    uninstallPackage = uninstallPackage,
    updatePrograms = updatePrograms
}