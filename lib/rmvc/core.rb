#!/usr/bin/env ruby
require 'colorize'
require 'sqlite3'
module RMVC
# Core (commands)
  class Core
    def self.migrate(mName)
      # Check if we're in a RMVC project
      if (!File.directory? ".rmvc") then
        puts "error".red + "        Not a RMVC project! (missing directory .rmvc)"
        exit
      end

      # Check if the migration exists
      unless File.exists? "app/migrations/#{mName}.rb"
        puts "error".red + "        The migration #{mName} doesn't exist!"
        exit
      end

      # Run the file
      puts "attempting to migrate #{mName}...".yellow
      sta = system ("ruby app/migrations/#{mName}.rb")
      if sta
        puts "#{mName} migrated correctly!".green
      else
        puts "error while migrating #{mName}".red
      end
    end

    def self.generate(args)
      # Check if we're in a RMVC project
      if (!File.directory? ".rmvc") then
        puts "error".red + "        Not a RMVC project! (missing directory .rmvc)"
        exit
      end
      if (args[1] == "model") then
        puts "Generating model #{args[2]}..."
        # Create file /app/models/args[2].rb
        if (File.exists? "app/models/#{args[2].downcase}.rb") then
          puts "error".red + "        File /app/models/#{args[2].downcase}.rb already exists."
          exit
        end
        File.open("app/models/#{args[2].downcase}.rb", "w") do |f|
          f.write(RMVC::Helpers.createModel(args[2]))
        end
        puts "create".green + "        File /app/models/#{args[2].downcase}.rb"
      elsif (args[1] == "controller")
        puts "Generating controller #{args[2]}..."
        # Create file /app/controllers/args[2]_controller.rb
        if (File.exists? "app/controllers/#{args[2].downcase}_controller.rb") then
          puts "error".red + "        File /app/controller/#{args[2].downcase}_controller.rb already exists."
          exit
        end
        File.open("app/controllers/#{args[2].downcase}_controller.rb", "w") do |f|
          f.write(RMVC::Helpers.createController(args[2]))
        end
        puts "create".green + "        File /app/controllers/#{args[2].downcase}_controller.rb"
        puts "notice".yellow + "        Remember to add a require statement to the main file of the project, to include app/controllers/#{args[2].downcase}_controller."
      elsif (args[1] == "view")
        puts "Generating view #{args[2]}..."
        # Create file /app/controllers/args[2]_controller.rb
        if (File.exists? "app/views/#{args[2].downcase}.rb") then
          puts "error".red + "        File /app/views/#{args[2].downcase}.rb already exists."
          exit
        end
        File.open("app/views/#{args[2].downcase}.rb", "w") do |f|
          f.write(RMVC::Helpers.createView(args[2], args[3]))
        end
        puts "create".green + "        File /app/views/#{args[2].downcase}.rb"
      elsif (args[1] == "migration")
        puts "Generating migration #{args[2]}..."
        # Create file /app/migrations/args[2].rb
        if (File.exists? "app/migrations/#{args[2].downcase}.rb") then
          puts "error".red + "        File /app/migrations/#{args[2].downcase}.rb already exists."
          exit
        end
        File.open("app/migrations/#{args[2].downcase}.rb", "w") do |f|
          f.write(RMVC::Helpers.createMigration(args[2], args[3]))
        end
        puts "create".green + "        File /app/migrations/#{args[2].downcase}.rb"
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

      # Create /app/migrations
      Dir.mkdir(projectname + "/app/migrations")
      puts "create".green + "        Directory /app/migrations"
      puts "create".green + "        Directory /db"
      Dir.mkdir(projectname + "/db")
      puts "reminder".yellow + "      You have to generate a new migration if you're using a database."
    end
  end
end