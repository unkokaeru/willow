local constants = require("config.constants")

local function getLatestManifest()
    local request = http.get(constants.MANIFEST_URL)
    if request then
        local manifest = textutils.unserialiseJSON(request.readAll())
        request.close()
        return manifest
    end
    error("Failed to get latest manifest")
end

local function downloadFile(sourceUrl, downloadPath)
    local request = http.get(sourceUrl)
    if request then
        local fileContents = request.readAll()
        request.close()

        local f = fs.open(downloadPath, "w")
        f.write(fileContents)
        f.close()
        print("Downloaded: " .. downloadPath)
    else
        error("Failed to download file from " .. sourceUrl)
    end
end

return {
    getLatestManifest = getLatestManifest,
    downloadFile = downloadFile
}