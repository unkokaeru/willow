local packageManager = require("modules.package_manager")

local function usage()
    print("Usage: willow <command>")
    print("Commands:")
    print("  get <package> - Download a package from the repository")
    print("  remove <package> - Uninstall a package")
    print("  upgrade - Update all previously downloaded programs")
    print("  list - List all available packages")
    print("  list-installed - List all installed packages")
end

local function handleArgs()
    if #arg == 0 then
        usage()
        return
    end

    if arg[1] == "get" then
        if #arg < 2 then
            print("Usage: willow get <package>")
            return
        end
        packageManager.downloadPackage(arg[2])
    elseif arg[1] == "remove" then
        if #arg < 2 then
            print("Usage: willow remove <package>")
            return
        end
        packageManager.uninstallPackage(arg[2])
    elseif arg[1] == "upgrade" then
        packageManager.updatePrograms()
    elseif arg[1] == "list" then
        packageManager.showAvailablePackages()
    elseif arg[1] == "list-installed" then
        packageManager.showInstalledPackages()
    else
        print("Unknown command: '" .. arg[1] .. "'")
        usage()
    end
end

return {
    handleArgs = handleArgs,
    usage = usage
}