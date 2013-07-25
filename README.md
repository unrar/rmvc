Ruby MVC
-------
Ruby MVC (`rmvc`) is a gem to help you use the MVC (Model-View-Controller) architecture in all your Ruby applications. It's not limited to web applications like Rails! In fact, it's like a *Rails without Rack*.

Usage
====
First, create a new project:

    rmvc new ProjectName

This will create all the needed files in the `ProjectName` subdirectory.
It will create a structure like the following:

    ProjectName/
      app/
        controllers/
          default_controller.rb
        models/
          default.rb
        views/
          main.rb
    ProjectName.rb

The file the user will run is `ProjectName.rb`. Its content should be something like this:

    require 'controllers/default_controller'
    DefaultController.main

The contents of the default controller:

    require '../models/default.rb'
    require '../views/main.rb'
    class DefaultController
      class << self
        # Add your variables here!
        attr_accessor :name
      end
      @name = "James!"
      def main
        MainView.load
      end
    end

And the contents of the view:

    require '../controllers/default_controller'
    class MainView
      def load
        puts "Hello, hello {#DefaultController.name}!"
      end
    end

How to work with it
===
It's very simple.
