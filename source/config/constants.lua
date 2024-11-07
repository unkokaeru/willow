--- Constants used by the Willow package manager.
--- @module "config.constants"

local colors = require("colors")

local constants = {}


--- REPOSITORY CONSTANTS ---
-- Repostiory URL
constants.REPO_URL = "https://raw.githubusercontent.com/unkokaeru/willow/"

-- Repository branch
constants.REPO_BRANCH = "main/"

-- Repository source path
constants.REPO_PATH = "source/"


--- FILE CONSTANTS ---
-- Hidden directory
constants.HIDDEN_DIRECTORY = ".willow/"

-- Packages directory
constants.PACKAGES_DIRECTORY = "packages/"

-- Local libraries directory
constants.LOCAL_LIBRARIES_DIRECTORY = "/usr/lib/willow-packages/"

-- Database file
constants.DATABASE_FILE = "willow-database.json"

-- Installed packages file
constants.INSTALLED_PACKAGES_FILE = "installed-packages.json"

-- Blank packages template
constants.BLANK_PACKAGES = {
    packages = {},
}

-- TODO: Move path constants to a paths module


--- UUID CONSTANTS ---
-- UUID template
constants.UUID_TEMPLATE = 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'


--- COLOUR CONSTANTS (library uses US spelling) ---
-- Default text colour
constants.DEFAULT_TEXT_COLOUR = colors.white

-- Error text colour
constants.ERROR_COLOUR = colors.red

-- Success text colour
constants.SUCCESS_COLOUR = colors.green

-- Warning text colour
constants.WARNING_COLOUR = colors.yellow

-- Info text colour
constants.INFO_COLOUR = colors.blue

-- Empty text colour
constants.EMPTY_COLOUR = colors.gray


--- LOGGING CONSTANTS ---
-- Datetime format
constants.DATETIME_FORMAT = "%Y-%m-%d %H:%M:%S"

-- Default log level
constants.DEFAULT_LOG_LEVEL = "INFO"

return constants