--- Functions for logging.
--- @module "modules.logging"

local constants = require("config.constants")
local print_utilities = require("utilities.print_utilities")

local logging = {}

local Logger = {}
Logger.__index = Logger  -- Redirect lookups to the Logger table to simulate inheritance.

-- Define log levels with corresponding numeric values and colors.
local LEVELS = {
    TRACE = { name = "TRACE", value = 1, color = constants.EMPTY_COLOUR },
    DEBUG = { name = "DEBUG", value = 2, color = constants.DEFAULT_TEXT_COLOUR },
    INFO = { name = "INFO", value = 3, color = constants.DEFAULT_TEXT_COLOUR },
    WARN = { name = "WARN", value = 4, color = constants.WARNING_COLOUR },
    ERROR = { name = "ERROR", value = 5, color = constants.ERROR_COLOUR },
    FATAL = { name = "FATAL", value = 6, color = constants.ERROR_COLOUR },
}

--- Create a new logger instance.
--- @param name string The name of the logger.
--- @param log_file string The file to log to.
--- @param level string The minimum log level to log messages.
--- @return table Logger A new logger instance.
function Logger:new(name, log_file, level)
    local instance = {
        _name = name,
        _log_file = log_file,
        _level = level and LEVELS[level].value or LEVELS.INFO.value, -- Default to INFO level.
    }

    -- Create the log file if it doesn't exist.
    if not fs.exists(log_file) then
        local file = fs.open(log_file, "w")  -- Create the file.
        file.close()
    end

    setmetatable(instance, self)  -- Simulate inheritance.
    self.__index = self  -- Ensure that the instance can access methods in Logger.
    return instance
end

--- Check if the current log level allows logging the message.
--- @param level string The level of the message.
--- @return boolean should_log True if the message should be logged, false otherwise.
function Logger:should_log(level)
    return LEVELS[level].value >= self._level
end

--- Format a log message.
--- @param level string The level of the message.
--- @param message string The message to log.
--- @return string formatted_message The formatted log message.
local function format_log_message(level, message)
    return string.format("(%s) [%s] %s", os.date(constants.DATETIME_FORMAT), level, message)
end

--- Logs a message.
--- @param message string The message to log.
--- @param level string The level of the message.
function Logger:log(message, level)
    if not self:should_log(level) then
        return  -- Skip logging if the level is too low.
    end

    local log_message = format_log_message(level, message)

    if self._log_file then
        local file, error = fs.open(self._log_file, "a")
        if not file then
            print_utilities.pretty_print(
                "Error opening log file: " .. error,
                constants.ERROR_COLOUR
            )
            return
        end
        file.writeLine(log_message)
        file.close()
    end

    print_utilities.pretty_print(log_message, LEVELS[level].color)
end

--- Log a trace message.
--- @param message string The message to log.
function Logger:trace(message)
    self:log(message, LEVELS.TRACE.name)
end

--- Log a debug message.
--- @param message string The message to log.
function Logger:debug(message)
    self:log(message, LEVELS.DEBUG.name)
end

--- Log an info message.
--- @param message string The message to log.
function Logger:info(message)
    self:log(message, LEVELS.INFO.name)
end

--- Log a warning message.
--- @param message string The message to log.
function Logger:warn(message)
    self:log(message, LEVELS.WARN.name)
end

--- Log an error message.
--- @param message string The message to log.
function Logger:error(message)
    self:log(message, LEVELS.ERROR.name)
    error(message)
end

--- Log a fatal message.
--- @param message string The message to log.
function Logger:fatal(message)
    self:log(message, LEVELS.FATAL.name)
end

local loggers = {}

--- Get a logger by name, creating it if it doesn't exist.
--- @param name string The name of the logger.
--- @param log_file string The file to log to.
--- @param level string|nil The minimum log level to log messages.
--- @return table Logger The logger instance.
function logging.get_logger(name, log_file, level)
    if not level then
        level = constants.DEFAULT_LOG_LEVEL
    end

    if not loggers[name] then
        loggers[name] = Logger:new(name, log_file, level)
    end
    return loggers[name]
end

return logging