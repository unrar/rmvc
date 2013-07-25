#!/usr/bin/env ruby
require 'colorize'
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
      elsif args[0] == "generate"
        # Generate code
        RMVC::Core.generate(args)
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

  # Core (commands)
  class Core
    def self.generate(whatever)
      puts "Placeholder"
    end
    # CMD: new [ProjectName]
    def self.create(projectname)
      puts "Creating new project: #{projectname}"
      puts ""
      # Check if directory exists
      if (File.directory? projectname) then
        puts "error".red + "        Directory #{projectname} already exists."
        exit
      end
      # Try to create it
      if (!Dir.mkdir(projectname)) then
        puts "error".red + "        Error while creating the directory #{projectname}"
        exit
      else
        puts "create".green + "        Directory #{projectname}"
      end
      # Create file projectname.rb
      File.open(projectname + "/" + projectname + ".rb", "w") do |f|
        f.write("require './app/controllers/default_controller'\n")
        f.write("DefaultController.main\n")
      end
      puts "create".green + "        File #{projectname}.rb"

      # Create directory app
      Dir.mkdir(projectname + "/app")
      puts "create".green + "        Directory /app"
      # Create directory app/controllers
      Dir.mkdir(projectname + "/app/controllers")
      puts "create".green + "        Directory /app/controllers"
      # Create default controller
      File.open(projectname + "/app/controllers/default_controller.rb", "w") do |f|
        f.write("require './app/models/default'\n")
        f.write("require './app/views/main'\n")
        f.write("class DefaultController\n")
        f.write("  class << self\n")
        f.write("    #Add your variables here!\n")
        f.write("    attr_accessor :name\n")
        f.write("  end\n")
        f.write("  @name = \"James!\"\n")
        f.write("  def self.main\n")
        f.write("    MainView.load\n")
        f.write("  end\n")
        f.write("end\n")
      end
      puts "create".green + "        File /app/controllers/default_controller.rb"
      # Create directory app/views
      Dir.mkdir(projectname + "/app/views")
      puts "create".green + "        Directory /app/views"
      # Create /app/views/main.rb
      File.open(projectname + "/app/views/main.rb", "w") do |f|
        f.write("require './app/controllers/default_controller'\n")
        f.write("class MainView\n")
        f.write("  def self.load\n")
        f.write("    puts \"Hello, hello \#{DefaultController.name}!\"\n")
        f.write("  end\n")
        f.write("end\n")
      end
      puts "create".green + "        File /app/views/main.rb"

      # Create /app/models
      Dir.mkdir(projectname + "/app/models")
      puts "create".green + "        Directory /app/models"
      # Create /app/models/default.rb
      File.open(projectname + "/app/models/default.rb", "w") do |f|
        f.write("require './app/controllers/default_controller'\n")
        f.write("class DefaultModel\n")
        f.write("end\n")
      end
      puts "create".green + "        File /app/models/default.rb"
    end
  end
end