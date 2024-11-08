--- Utility functions for working with printing.
--- @module "utilities.print_utilities"

local constants = require("config.constants")


local print_utilities = {}


--- Prints text with a specified colour.
--- @param text string The text to print.
--- @param colour number|nil The colour to print the text in, or nil to use the default text colour.
function print_utilities.pretty_print(text, colour)
    if colour == nil then
        colour = constants.DEFAULT_TEXT_COLOUR
    end

    term.setTextColor(colour)
    print(text)
    term.setTextColor(constants.DEFAULT_TEXT_COLOUR)
end


return print_utilities