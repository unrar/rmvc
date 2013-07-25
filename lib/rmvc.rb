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
        if (args.length < 3) then
          puts "Wrong syntax for 'generate'!"
          RMVC::Interface.showHelp
        elsif (args[1] == "view" && args.length < 4)
          puts "Wrong syntax for 'generate view'!"
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
      puts "    new [ProjectName]"
      puts "      where [ProjectName] is the name of your new project"
      puts "        Creates a new project using the RMVC architecture."
      puts ""
      puts "    generate [model|controller|view] [name] [controllerName]"
      puts "      where [name] is the name of the model/controller/view"
      puts "        Creates a new model/controller/view with the desired name."
      puts "        If a controller is created, it will automatically be linked (through require) to a model "
      puts "        and a view of the same name than the controller."
      puts "        If a model is created, it will be linked (through require) to a controller of the same name."
      puts "        If a view is created, you must specify [controllerName]. It will be linked (through require) to it."
      puts ""
    end
  end

  # Core (commands)
  class Core
    def self.generate(args)
      # Check if we're in a RMVC project
      if (!File.directory? ".rmvc") then
        puts "error".red + "        Not a RMVC project! (missing directory .rmvc)"
        exit
      end
      if (args[1] == "model") then
        puts "Generating model #{args[2]}..."
        # Create file /app/models/args[2].rb
        if (File.exists? "app/models/#{args[2]}.rb") then
          puts "error".red + "        File /app/models/#{args[2]}.rb already exists."
          exit
        end
        File.open("app/models/#{args[2]}.rb", "w") do |f|
          f.write(RMVC::Helpers.createModel(args[2]))
        end
        puts "create".green + "        File /app/models/#{args[2]}.rb"
      elsif (args[1] == "controller")
        puts "Generating controller #{args[2]}..."
        # Create file /app/controllers/args[2]_controller.rb
        if (File.exists? "app/controllers/#{args[2]}_controller.rb") then
          puts "error".red + "        File /app/controller/#{args[2]}_controller.rb already exists."
          exit
        end
        File.open("app/controllers/#{args[2]}_controller.rb", "w") do |f|
          f.write(RMVC::Helpers.createController(args[2]))
        end
        puts "create".green + "        File /app/controllers/#{args[2]}_controller.rb"
        puts "notice".yellow + "        Remember to add a require statement to the main file of the project, to include app/controllers/#{args[2]}_controller."
      elsif (args[1] == "view")
        puts "Generating view #{args[2]}..."
        # Create file /app/controllers/args[2]_controller.rb
        if (File.exists? "app/views/#{args[2]}.rb") then
          puts "error".red + "        File /app/views/#{args[2]}.rb already exists."
          exit
        end
        File.open("app/views/#{args[2]}.rb", "w") do |f|
          f.write(RMVC::Helpers.createView(args[2], args[3]))
        end
        puts "create".green + "        File /app/views/#{args[2]}.rb"
      else
        puts "Wrong argument for generate: #{args[1]}"
        RMVC::Interface.showHelp
      end
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
      # Create directory .rmvc
      Dir.mkdir(projectname + "/.rmvc")
      puts "create".green + "        Directory #{projectname}/.rmvc"
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

  # Helpers
  class Helpers
    # Helper for creating a controller
    def self.createController(controllerName)
      controllerCap = controllerName.capitalize
        "require './app/models/#{controllerName}'
require './app/views/#{controllerName}'
class #{controllerCap}Controller
  class << self
    #Add your variables here!
    attr_accessor :name
  end
  @name = \"James!\"
  def self.main
     #{controllerCap}View.load
  end
end\n"
    end
  # Helper for creating a view
    def self.createView(viewName, controllerName)
      viewCap = viewName.capitalize
"require './app/controllers/#{controllerName}_controller'
class #{viewCap}View
  def self.load
    puts \"Hello, hello!\"
  end
end\n"
    end

  # Helper for creating a model
    def self.createModel(modelName)
"require './app/controllers/#{modelName}_controller'
class #{modelName.capitalize}Model
end\n"
    end
  end
end