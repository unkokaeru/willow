--- The main entry point for the application.
--- @file main.lua
--- @date 2024-11-07
--- @version 0.1.0
--- @license MIT
--- @author William Fayers

local shell = require("cc.shell")

local command_line_interface = require("modules.command_line_interface")
local logging = require("modules.logging")

local logger = logging.get_logger("main", "main.log")

--- The main entry point for the application.
--- @return number The exit code.
local function main()
    logger:trace("Starting application.")
    shell.setCompletionFunction(
        shell.getRunningProgram(),
        command_line_interface.complete
    )

    logger:debug("Parsing arguments.")
    command_line_interface.argument_handler(arg)

    return 0
end


return main()