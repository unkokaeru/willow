local logger = require("logger")
local cli = require("cli")

-- Set the desired log level (optional)
logger.set_level("DEBUG")

-- Handle command-line arguments
cli.handle_commands()

-- Example logging
logger.info("Willow has started.")