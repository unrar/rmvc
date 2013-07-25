#!/usr/bin/env ruby

module RMVC
  # Interface
  class Interface
    # Startup
    def self.startup(args)
      if (args != "none") then
        RVMC::Interface.run(args)
      else
        # No ARGS
        RMVC::Interface.showHelp
      end
    end

    # Run a command
    def run(args)
      fullArgs = args.join(" ")
      # Validate first argument
      if args[0] == "new" then
        # Create a new project
        if (args.length >= 2) then
          RVMC::Core.create(args[1])
        else
          puts "Wrong syntax for 'new'!"
          RMVC::Interface.showHelp
        end
      elsif args[0] == "generate"
        # Generate code
        RMVC::Core.generate(args)
      else
        # Unknown command
        RMVC::Interface.showHelp
      end
    end

    # Show help
    def showHelp
      puts "You introduced an invalid command, or you've ran rmvc without arguments."
      puts "Syntax: rmvc [command] [arguments ...]"
      puts "The following commands are available: "
      puts ""
      puts "    new [ProjectName]"
      puts "      where [ProjectName] is the name of your new project"
      puts "        Creates a new project using the RMVC architecture."
      puts ""
      puts "    generate [model|controller|view] [name]"
      puts "      where [name] is the name of the model/controller/view"
      puts "        Creates a new model/controller/view with the desired name."
      puts ""
  end
end