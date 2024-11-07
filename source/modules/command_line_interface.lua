--- Command line interface for Willow.
--- @module "modules.command_line_interface"

local completion = require("cc.completion")

local constants = require("config.constants")
local logging = require("modules.logging")
local package_manager = require("modules.package_manager")
local print_utilities = require("utilities.print_utilities")

local logger = logging.get_logger("command_line_interface", "command_line_interface.log")

local POSSIBLE_COMMANDS = {
    "show",
    "install",
    "uninstall",
    "update"
}  -- TODO: Use this to dynamically build the usage message

local command_line_interface = {}


--- Completion function for the command line interface.
--- @param _ table The current environment.
--- @param current_argument_index number The current argument index.
--- @param current_argument string The current argument.
--- @param previous_arguments string The previous arguments.
function command_line_interface.complete(
    _,
    current_argument_index,
    current_argument,
    previous_arguments
)
    logger.trace("Completing argument: " .. current_argument)
    if current_argument_index == 1 then
        logger.trace("Completing command")
        return completion.choice{
            current_argument,
            POSSIBLE_COMMANDS,
            true,  -- Add a space after the completion
        }
        -- TODO: Separate command names into constants
    elseif current_argument_index == 2 then
        local completables = {}
        local packages = {}

        logger.trace("Completing package name")

        if previous_arguments == "install" then
            packages = package_manager._fetch_database()
        elseif previous_arguments == "uninstall" then
            packages = package_manager._load_installed_packages()
        elseif previous_arguments == "update" then
            packages = package_manager._load_installed_packages()
            completables = {"all"}
        end

        for _, package in pairs(packages) do
            logger.trace("Adding package '" .. package.name .. "' to completables")
            table.insert(completables, package.name)
        end

        return completion.choice(current_argument, completables)
    end
end
-- TODO: Generalise the completion function to work with any command


--- Separates the command from the arguments.
--- @param arguments table The arguments to separate.
--- @return string command The command.
--- @return table command_arguments The arguments for the command.
function command_line_interface._separate_command(arguments)
    local total_arguments = #arguments
    local command = arguments[1]
    local command_arguments = {}

    logger.trace("Separating command from arguments")

    if total_arguments == 1 then
        logger.trace("No arguments provided")
        return command, command_arguments
    end

    for index = 2, total_arguments do
        logger.trace("Adding argument '" .. arguments[index] .. "' to command arguments")
        table.insert(command_arguments, arguments[index])
    end

    return command, command_arguments
end


--- Handles the arguments passed to the command line interface.
--- @param arguments table The arguments to handle.
function command_line_interface.argument_handler(arguments)
    local command, command_arguments = command_line_interface._separate_command(arguments)

    logger.trace("Handling command: " .. command)

    if not command then
        print_utilities.pretty_print("Usage: package_manager <command>", constants.INFO_COLOUR)
        print_utilities.pretty_print("Commands:", constants.INFO_COLOUR)
        print_utilities.pretty_print("  show", constants.INFO_COLOUR)
        print_utilities.pretty_print("  install <package>", constants.INFO_COLOUR)
        print_utilities.pretty_print("  uninstall <package>", constants.INFO_COLOUR)
        print_utilities.pretty_print("  update <package | all>", constants.INFO_COLOUR)
        -- TODO: Build the usage message dynamically
        return
    end

    logger.trace("Command: " .. command)

    if command == "show" then
        package_manager.show_packages()
    elseif #command_arguments == 0 and POSSIBLE_COMMANDS[command] then
        print_utilities.pretty_print(
            "Usage: package_manager " .. command .. " <package>",
            constants.INFO_COLOUR
        )
        return
    elseif command == "install" then
        package_manager.install_package(command_arguments[1])
    elseif command == "uninstall" then
        package_manager.uninstall_package(command_arguments[1])
    elseif command == "update" then
        if command_arguments[1] == "all" then
            package_manager.update_all_packages()
        else
            package_manager.update_package(command_arguments[1])
        end
    else
        print_utilities.pretty_print(
            "Command '" .. command .. "' not found.",
            constants.ERROR_COLOUR
        )
    end

    logger.trace("Command handled")
end


return command_line_interface