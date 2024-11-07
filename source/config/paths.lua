--- Paths used by the Willow package manager.
--- @module "config.paths"

local constants = require("config.constants")

local paths = {}


-- Willow database URL
paths.willow_database = constants.REPO_URL ..
				constants.REPO_BRANCH ..
				constants.REPO_PATH ..
				constants.DATABASE_FILE

-- Local installed packages file
paths.installed_packages = constants.HIDDEN_DIRECTORY ..
                constants.INSTALLED_PACKAGES_FILE

-- Packages URL
paths.willow_packages = constants.REPO_URL ..
                constants.REPO_BRANCH ..
                constants.PACKAGES_DIRECTORY

-- Local packages directory
paths.local_packages = constants.LOCAL_PACKAGES_DIRECTORY

return paths