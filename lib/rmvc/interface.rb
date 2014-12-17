#!/usr/bin/env ruby
require 'colorize'
require 'sqlite3'
module RMVC
  # Interface
  class Interface
    # Startup
    def self.startup(args)
      if (args != "none") then
        RMVC::Interface.run(args)
      else
        # No ARGS
        RMVC::Interface.showHelp
      end
    end

    # Run a command
    def self.run(args)
      fullArgs = args.join(" ")
      # Validate first argument
      if args[0] == "new" then
        # Create a new project
        if (args.length >= 2) then
          RMVC::Core.create(args[1])
        else
          puts "Wrong syntax for 'new'!"
          RMVC::Interface.showHelp
        end
      elsif args[0] == "migrate"
        if args.length < 2
          puts "Wrong syntax for 'migrate'!"
          RMVC::Interface.showHelp
        else
          RMVC::Core.migrate(args[1])
        end
      elsif args[0] == "generate"
        # Generate code
        if (args.length < 3) then
          puts "Wrong syntax for 'generate'!"
          RMVC::Interface.showHelp
        elsif (args[1] == "view" && args.length < 4)
          puts "Wrong syntax for 'generate view'!"
          RMVC::Interface.showHelp
        elsif (args[1] == "migration" && args.length < 4)
          puts "Wrong syntax for 'generate migration'!"
          RMVC::Interface.showHelp
        else
          RMVC::Core.generate(args)
        end
      else
        # Unknown command
        RMVC::Interface.showHelp
      end
    end

    # Show help
    def self.showHelp
      puts "You introduced an invalid command, or you've ran rmvc without arguments."
      puts "Syntax: rmvc [command] [arguments ...]"
      puts "The following commands are available: "
      puts ""
      puts "    new [ProjectName]".yellow
      puts "      where [ProjectName] is the name of your new project".green
      puts "        Creates a new project using the RMVC architecture."
      puts ""
      puts "    generate [model|controller|view|migration] [name] [controllerName|dbName]".yellow
      puts "      where [name] is the name of the model/controller/view".green
      puts "        Creates a new model/controller/view with the desired name."
      puts "        If a controller is created, it will automatically be linked (through require) to a model "
      puts "        and a view of the same name than the controller."
      puts "        If a model is created, it will be linked (through require) to a controller of the same name."
      puts "        If a view is created, you must specify [controllerName]. It will be linked (through require) to it."
      puts "        If a migration is created, a file in /app/migrations will be created. A database must be specified."
      puts ""
      puts "    migrate [migration]".yellow
      puts "      where [migration] is the name of the migration previously created.".green
      puts "        Runs the queries written in a migration file to a database."
      puts "        If the database doesn't exist, it will be created."
      puts ""
    end
  end
end