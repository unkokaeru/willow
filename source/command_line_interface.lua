local cli = {}

-- Function to parse command-line arguments
function cli.parse_args()
    local args = {}
    for i = 1, #arg do
        args[i] = arg[i]
    end
    return args
end

-- Function to display help information
function cli.show_help()
    print("Usage: willow [options]")
    print("Options:")
    print("  --help      Show this help message")
    print("  --version   Show the version of Willow")
    -- Add more options as needed
end

-- Function to handle commands
function cli.handle_commands()
    local args = cli.parse_args()

    if #args == 0 then
        print("No command provided. Use --help for usage information.")
        return
    end

    for _, arg in ipairs(args) do
        if arg == "--help" then
            cli.show_help()
            return
        elseif arg == "--version" then
            print("Willow version 1.0.0")  -- Replace with dynamic version if needed
            return
        else
            print("Unknown command: " .. arg)
            cli.show_help()
            return
        end
    end
end

return cli