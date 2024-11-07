--- Functions for managing packages.
--- @module "modules.package_manager"

local textutils = require("textutils")

local constants = require("config.constants")
local logging = require("modules.logging")
local file_utilities = require("utilities.file_utilities")
local network_utilities = require("utilities.network_utilities")
local paths = require("config.paths")
local print_utilities = require("utilities.print_utilities")

local logger = logging.get_logger("package_manager", "package_manager.log")

local package_manager = {}


--- Loads the installed packages.
--- @return table installed_packages The installed packages.
function package_manager._load_installed_packages()
    logger.trace("Loading installed packages")
    local installed_packages = file_utilities.read_json(paths.installed_packages)
    logger.trace("Installed packages loaded")

    if not installed_packages then
        logger.debug("No installed packages found, using blank packages")
        installed_packages = constants.BLANK_PACKAGES
    end

    return installed_packages
end


--- Saves the installed packages.
--- @param installed_packages table The installed packages.
function package_manager._save_installed_packages(installed_packages)
    logger.trace("Saving installed packages")
    local success = file_utilities.write_json(paths.installed_packages, installed_packages)

    if not success then
        logger.error("Failed to save the installed packages.")
    end
end


--- Fetches the database file.
--- @return table overview The database contents.
function package_manager._fetch_database()
    logger.trace("Fetching the database file")
    local database_string = network_utilities.download_file(paths.willow_database, true)

    if not database_string then
        logger.error("Failed to fetch the database file.")
    end

    local database_table = textutils.unserialiseJSON(database_string)
    if not database_table then
        logger.error("Failed to parse the database file.")
    end

    logger.trace("Database file fetched")
    return database_table
end


--- Shows the available packages.
function package_manager.show_packages()
    logger.trace("Showing packages")
    local database = package_manager._fetch_database()

    logger.info("Packages: ")
    print_utilities.pretty_print("Packages:", constants.INFO_COLOUR)

    for _, package in pairs(database.packages) do
        local package_colour = constants.EMPTY_COLOUR
        -- TODO: Implement package colouring based on installed status

        logger.info("  - " .. package.name .. " (" .. package.version .. ")")
        print_utilities.pretty_print(
            "- " .. package.name .. " (" .. package.version .. ")",
            package_colour
        )
        logger.info("  *" .. package.description .. "*")
        print_utilities.pretty_print(
            "  *" .. package.description .. "*",
            package_colour
        )

        if package.dependencies then
            logger.info("  Dependencies:")
            print_utilities.pretty_print("  Dependencies:")

            local dependency_colour = constants.EMPTY_COLOUR
            -- TODO: Implement dependency colouring based on installed status

            for dependency, version in pairs(package.dependencies) do
                logger.info("    - " .. dependency .. " (" .. version .. ")")
                print_utilities.pretty_print(
                    "  - " .. dependency .. " (" .. version .. ")",
                    dependency_colour
                )
            end
        end
    end
end


--- Installs a package.
--- @param package_name string The name of the package to install.
function package_manager.install_package(package_name)
    logger.trace("Installing package: " .. package_name)
    local database = package_manager._fetch_database()
    local installed_packages = package_manager._load_installed_packages()

    local package = database.packages[package_name]
    if not package then
        logger.error("Package '" .. package_name  .. "' not found in the database.")
        -- TOdo: Suggest similar packages if the package is not found
    end
    logger.trace("Package found in the database: " .. package_name)

    if installed_packages.packages[package_name] then
        logger.trace("Package '" .. package_name .. "' is already installed.")
        if installed_packages.packages[package_name].version == package.version then
            logger.warning("Package '" .. package_name .. "' is already installed.")
            print_utilities.pretty_print(
                "Package '" .. package_name .. "' is already installed.",
                constants.WARNING_COLOUR
            )
        else
            logger.warning("Package '" .. package_name .. "' is already installed, " ..
                            "but the installed version is different.")
            print_utilities.pretty_print(
                "Package '" .. package_name .. "' is already installed, " ..
                "but the installed version is different. Please upgrade the package instead.",
                constants.WARNING_COLOUR
            )
            -- TODO: Implement automatic package upgrading
        end

        return
    end

    logger.info("Installing " .. package.name .. " (" .. package.version .. ")...")
    print_utilities.pretty_print("Installing " .. package.name .. " (" .. package.version .. ")...")

    if package.dependencies then
        local dependency_count = #package.dependencies
        logger.info("Package has " .. dependency_count .. " dependencies.")
        print_utilities.pretty_print(
            "Package has " .. dependency_count .. " dependencies."
        )

        for dependency, version in pairs(package.dependencies) do
            logger.info("Installing dependency '" .. dependency .. "' (" .. version .. ")...")
            print_utilities.pretty_print(
                "Installing dependency '" .. dependency .. "' (" .. version .. ")..."
            )

            package_manager.install_package(dependency)
        end
    end

    local package_url = paths.willow_packages .. package.name .. ".lua"
    -- TODO: Extend to support directories of files
    logger.debug("Downloading package '" .. package.name .. "' from " .. package_url .. "...")

    local package_contents = network_utilities.download_file(package_url, true)
    if not package_contents then
        logger.warning("Failed to download package '" .. package.name .. "'.")
        return
    end

    local file_write_success = file_utilities.write_file(
        paths.local_packages .. package.name .. ".lua",
        package_contents
    )

    if not file_write_success then
        logger.warning("Failed to install package '" .. package.name .. "'.")
        return
    end

    installed_packages.packages[package.name] = package
    package_manager._save_installed_packages(installed_packages)

    logger.info("Package '" .. package.name .. "' (" .. package.version .. ") installed.")
    print_utilities.pretty_print(
        "Package '" .. package.name .. "' (" .. package.version .. ") installed successfully.",
        constants.SUCCESS_COLOUR
    )
end


--- Uninstalls a package.
--- @param package_name string The name of the package to uninstall.
function package_manager.uninstall_package(package_name)
    logger.trace("Uninstalling package: " .. package_name)
    local installed_packages = package_manager._load_installed_packages()
    local package = installed_packages.packages[package_name]

    if not package then
        logger.warning("Package '" .. package_name .. "' is not installed.")
        return
    end

    logger.info("Uninstalling package '" .. package.name .. "'...")
    print_utilities.pretty_print("Uninstalling package '" .. package.name .. "'...")

    local package_path = paths.local_packages .. package.name .. ".lua"
    logger.debug("Deleting package file: " .. package_path)

    local success = file_utilities.delete_file(package_path)
    if not success then
        logger.warning("Failed to uninstall package '" .. package_name .. "'.")
        return
    end

    installed_packages.packages[package_name] = nil
    package_manager._save_installed_packages(installed_packages)

    logger.info("Package '" .. package_name .. "' uninstalled.")
    print_utilities.pretty_print(
        "Package '" .. package_name .. "' uninstalled successfully.",
        constants.SUCCESS_COLOUR
    )
end


--- Updates a package.
--- @param package_name string The name of the package to update.
function package_manager.update_package(package_name)
    logger.trace("Updating package: " .. package_name)
    local database = package_manager._fetch_database()
    local installed_packages = package_manager._load_installed_packages()

    local package = database.packages[package_name]
    if not package then
        print_utilities.pretty_print(
            "Package '" .. package_name  .. "' not found in the database.",
            constants.ERROR_COLOUR
        )
    end
    -- TODO: Separate package checking into another function
    logger.trace("Package found in the database: " .. package_name)

    if not installed_packages.packages[package.name] then
        logger.warning("Package '" .. package.name .. "' is not installed. " ..
                        "Installing the package instead.")
        package_manager.install_package(package.name)
        return
    end

    if installed_packages.packages[package.name].version == package.version then
        logger.warning("Package '" .. package.name .. "' is already up-to-date.")
        return
    elseif installed_packages.packages[package.name].version > package.version then
        logger.warning("Package '" .. package.name .. "' " ..
                        "is a newer version than the database version.")
        return
    else
        logger.info("Updating package '" .. package.name .. "' from " ..
                    installed_packages.packages[package.name].version .. " to " ..
                    package.version .. "...")
        print_utilities.pretty_print(
            "Updating package '" .. package.name .. "' from " ..
            installed_packages.packages[package.name].version .. " to " .. package.version .. "..."
        )

        package_manager.uninstall_package(package.name)
        package_manager.install_package(package.name)

        logger.info("Package '" .. package.name .. "' updated.")
        print_utilities.pretty_print(
            "Package '" .. package.name .. "' updated successfully.",
            constants.SUCCESS_COLOUR
        )
    end
end


--- Updates all installed packages.
function package_manager.update_all_packages()
    logger.trace("Updating all installed packages")
    local database = package_manager._fetch_database()
    local installed_packages = package_manager._load_installed_packages()

    for _, package in pairs(installed_packages.packages) do
        if database.packages[package.name] then
            logger.info("Updating package '" .. package.name .. "'...")
            package_manager.update_package(package.name)
        end
    end
end


return package_manager