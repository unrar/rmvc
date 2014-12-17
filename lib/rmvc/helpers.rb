#!/usr/bin/env ruby
require 'colorize'
require 'sqlite3'
module RMVC
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