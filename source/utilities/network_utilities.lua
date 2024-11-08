--- Utility functions for working with networks.
--- @module "utilities.network_utilities"

local logging = require("modules.logging")
local string_utilities = require("utilities.string_utilities")

local logger = logging.get_logger("network_utilities", "network_utilities.log")

local network_utilities = {}


--- Prevents caching by appending a unique token to the URL.
--- @param url string The URL to prevent caching for.
--- @return string url The URL with a unique token appended.
function network_utilities.prevent_caching(url)
    logger.trace("Preventing caching for URL: " .. url)
    return url .. "?token=" .. string_utilities.generate_uuid()
end


--- Downloads the contents of a URL.
--- @param url string The URL to download from.
--- @param prevent_caching boolean Whether to prevent caching by appending a unique token to the URL.
--- @return string|nil response The response from the URL, or nil if the URL could not be downloaded.
function network_utilities.download(url, prevent_caching)
    logger.trace("Downloading URL: " .. url)
    if prevent_caching then
        url = network_utilities.prevent_caching(url)
    end

    logger.trace("Downloading URL (after preventing caching): " .. url)
    local request = http.get(url)
    logger.debug("Request: " .. request)
    if not request then
        logger.error("Error downloading URL: " .. url)
        return nil
    end

    local response = request.readAll()
    logger.trace("URL downloaded: " .. url)
    request.close()

    return response
end


return network_utilities