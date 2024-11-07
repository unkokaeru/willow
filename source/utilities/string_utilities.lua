--- Utility functions for working with strings.
--- @module "utilities.string_utilities"

local constants = require("config.constants")
local logging = require("modules.logging")

local logger = logging.get_logger("string_utilities", "string_utilities.log")

local string_utilities = {}


--- Generates a UUID (Universally Unique Identifier).
--- @return string uuid The generated UUID.
function string_utilities.generate_uuid()
    logger.trace("Generating UUID")
    local function generate_character(character)
        local random_value

        if character == 'x' then
            random_value = math.random(0, 0xf)  -- Random value for 'x' (0-15)
        else
            random_value = math.random(8, 0xb)  -- Random value for 'y' (8-11)
        end

        -- Format the random value as a hexadecimal string
        return string.format('%x', random_value)
    end

    local uuid = string.gsub(constants.UUID_TEMPLATE, '[xy]', generate_character)

    logger.trace("UUID generated: " .. uuid)
    return uuid
end


return string_utilities