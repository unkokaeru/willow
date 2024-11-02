local logger = {}

-- Log levels
logger.levels = {
    DEBUG = 1,
    INFO = 2,
    WARNING = 3,
    ERROR = 4,
}

-- Set the current log level (default is INFO)
logger.current_level = logger.levels.INFO

-- Function to set the log level
function logger.set_level(level)
    if logger.levels[level] then
        logger.current_level = logger.levels[level]
    else
        error("Invalid log level: " .. tostring(level))
    end
end

-- Function to log messages
function logger.log(level, message)
    if logger.levels[level] >= logger.current_level then
        print("[" .. level .. "] " .. message)
    end
end

-- Convenience functions for different log levels
function logger.debug(message)
    logger.log("DEBUG", message)
end

function logger.info(message)
    logger.log("INFO", message)
end

function logger.warning(message)
    logger.log("WARNING", message)
end

function logger.error(message)
    logger.log("ERROR", message)
end

return logger