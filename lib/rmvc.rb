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
      puts "create".green + "         Directory /app/migrations"
      puts "create".green + "         Directory /app/db"
      Dir.mkdir(projectName + "/app/db")
      puts "reminder".yellow + "      You have to generate a new migration if you're using a database."
    end
  end

  # Migration: an object to assist database creation
  class Migration
    # Init (create or open database)
    attr_accessor :dbr
    def initialize(database)
      if File.exists?("./db/" + database + ".db")
        puts "database #{database} already exists. opening...".green
        @dbr = SQLite3::Database.open("./db/" + database + ".db")
      else
        puts "database #{database} not found. creating database...".yellow
        begin
          @dbr = SQLite3::Database.new("./db/" + database + ".db")
          puts "database #{database} successfully created.".green
        rescue
          puts "couldn't create database. aborting...".red
          exit
        end
      end
    end

    # create table
    def create_table(table)
      puts "attempting to create table #{table}..."
      begin
        tt = @dbr.prepare("CREATE TABLE #{table}(id int auto_increment);")
        ee = tt.execute
        puts "table created correctly.".green
      rescue
        puts "error while creating table #{table}".red
        exit
      end
    end

    # add column
    def add_column(table, cname, type)
      if type.to_s == "text"
        puts "attempting to create text column #{cname} at #{table}..."
        begin
          tt = @dbr.prepare("ALTER TABLE #{table} ADD #{cname} text;")
          ee = tt.execute
          puts "column correctly added!".green
        rescue
          puts "error while adding column #{cname} to #{table}".red
          exit
        end
      elsif type.to_s == "num"
        puts "attempting to create numerical column #{cname} at #{table}..."
        begin
          tt = @dbr.prepare("ALTER TABLE #{table} ADD #{cname} int;")
          ee = tt.execute
          puts "column correctly added!".green
        rescue
          puts "error while adding column #{cname} to #{table}".red
          exit
        end
      else
        puts "attempting to create custom (#{type.to_s}) column #{cname} at #{table}..."
        begin
          tt = @dbr.prepare("ALTER TABLE #{table} ADD #{cname} #{type.to_s};")
          ee = tt.execute
          puts "column correctly added!".green
        rescue
          puts "error while adding column #{cname} to #{table}".red
          exit
        end     
      end
    end 

    # Insert values into table WHERE columns = ["column1", "column2"]
    # AND values = ["value1", "value2"]
    def insert(table, columns, values)
      puts "attempting to insert values into #{table}..."
        begin
          nvalues = []
          values.each do |v|
            if v.is_a? String
              nvalues << "\"" + v + "\"" 
            else
              nvalues << v
            end
          end
          tt = @dbr.prepare("INSERT INTO #{table}(" + columns.join(", ") + ") VALUES(" + nvalues.join(", ") + ");")
          ee = tt.execute
          puts "values correctly added!".green
        rescue
          puts "error while inserting values".red
        end
    end
  end

  # Helpers
  class Helpers
    # Helper for creating a controller
    def self.createController(controllerName)
      controllerCap = controllerName.slice(0,1).capitalize + controllerName.slice(1..-1)
        "require './app/models/#{controllerName.downcase}'
require './app/views/#{controllerName.downcase}'
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
      viewCap = viewName.slice(0,1).capitalize + viewName.slice(1..-1)
"require './app/controllers/#{controllerName.downcase}_controller'
class #{viewCap}View
  def self.load
    puts \"Hello, hello!\"
  end
end\n"
    end

  # Helper for creating a model
    def self.createModel(modelName)
"require './app/controllers/#{modelName.downcase}_controller'
class #{modelName.slice(0,1).capitalize + modelName.slice(1..-1)}Model
end\n"
    end

    # Helper for creating a migration
    def self.createMigration(migrationName, dbName)
"require 'rmvc'
m = RMVC::Migration.new(\"#{dbName}\")
# Insert migration commands here\n"
    end
  end
end
