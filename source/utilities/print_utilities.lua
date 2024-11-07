--- Utility functions for working with printing.
--- @module "utilities.print_utilities"

local term = require("term")

local constants = require("config.constants")
local logging = require("modules.logging")

local logger = logging.get_logger("print_utilities", "print_utilities.log")


local print_utilities = {}


--- Prints text with a specified colour.
--- @param text string The text to print.
--- @param colour number|nil The colour to print the text in, or nil to use the default text colour.
function print_utilities.pretty_print(text, colour)
    logger.trace("Pretty printing text: " .. text)
    if colour == nil then
        logger.trace("No colour specified, using default text colour")
        colour = constants.DEFAULT_TEXT_COLOUR
    end

    term.setTextColor(colour)
    logger.debug("Printing text: " .. text)
    print(text)
    term.setTextColor(constants.DEFAULT_TEXT_COLOUR)
    logger.trace("Text printed: " .. text)
end


return print_utilities