Ruby MVC [![Gem Version](https://badge.fury.io/rb/rmvc.png)](http://badge.fury.io/rb/rmvc)
-------
Ruby MVC (`rmvc`) is a gem to help you use the MVC (Model-View-Controller) architecture in all your Ruby applications. It's not limited to web applications like Rails! In fact, it's like a *Rails without Rack*.

Get RMVC
===
It's an official gem now! If you want the last available gem, run this:

    $ gem install rmvc

Depending on your setup, you might have to prefix the command with `sudo`.

If you want the last version and the gem isn't updated (look at the top of the README to know what version the gem is), just download the sources from GitHub:

    $ git init
    $ git clone https://github.com/unrar/rmvc.git

Now install the gem:

    $ gem install rmvc-x.x.x.gem

### Dependencies ###
The only dependency of RMVC is [colorize](https://rubygems.org/gems/colorize). Rubygems should automatically install colorize for you.

Create a project
====
RMVC is made to be friendly to Rails developers. So, as you can guess, the only command you need to run to create 
a new project is `new`:

    $ rmvc new ProjectName

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

The file the user will run is `ProjectName.rb`. It has a very simple content.

```ruby
require './app/controllers/default_controller'
DefaultController.main
```

The controller, which is the file that, obviously, **controls** everything, contains this by default:

```ruby
require './app/models/default'
require './app/views/main'
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
```

And the contents of the view:

```ruby
require './app/controllers/default_controller'
class MainView
  def load
    puts "Hello, hello {#DefaultController.name}!"
  end
end
```

The model is void by default, just a declaration of the class `SomethingModel`.

How does it work?
===
It's very simple. This is basically what happens:

1. The method `main` of `DefaultController` is invoked. 
2. The method `main` of `DefaultController`, following the conventions, invokes the view `main` (`MainView`), using the method `load` as the RMVC conventions say.
3. The method `load` of the `MainView` shows a message through `puts`, using a variable declared at `DefaultController`.

Declaring Variables
===
It's very easy! Just add the variable at the `attr_accessor` statement of your controller:

```ruby
attr_accessor :onevariable, :anothervariable, :myvariable
```

And declare it using an instance variable (`@var`) after the `class << self` block.

```ruby
end
@onevariable, @anothervariable, @myvariable = "A", "B", "C"
```

This can sound stupid, but it's useful if you want to get data from a database and make it available for all the views under
a controller (MVC rules!).

Generating new content
===
Of course, RMVC makes it easy for you to generate new models, views and controllers. It will take care of almost all the `require`s. 

**Important!** Make sure to be at the root of your project, not at the app subdirectory or any other one! That's because RMVC looks for the `.rmvc` directory to make sure you're in an actual project, and that directory is on the root.

**Important!** The case issues are fixed. You can now do `generate controller TheBoss`, and it will generate a file `theboss_controller.rb` but the class name will be `TheBossController`.
### Models ###
Models are the most simple component to create, since they're void by default. Use this command:

    $ rmvc generate model mylovelymodel

This will create the file `app/models/mylovelymodel.rb`. Following the conventions, it will add a `require` statement to include a controller also named `mylovelymodel` (`app/controllers/mylovelymodel_controller.rb`). Keep in mind that it will **NOT** create the controller too, so you're free to change the `require` line of the model to "link" it to another controller. But we strongly recommend to follow the conventions!

The class of the model will be named `MylovelymodelModel`.

### Views ###
This ones are a bit more complicated. You need to specify to which controller is any view. Keep in mind that, unlike Rails, there can't be two views with the same name. That's because RMVC is **simple**. So you can't have a view `main` for one controller and a view `main` for another controller. Use this command:

    $ rmvc generate view intro sudokusolver

This one will create a file at `app/views/intro.rb`, with a `require` statement "linking" to `app/controllers/sudokusolver_controller.rb`. Its class will be named `IntroView` with the default method `load`. 

### Controllers ###
These are the most complicated! Use this command:

    $ rmvc generate controller sudokusolver

And that's basically it! This creates a file `app/controllers/sudokusolver_controller.rb`. It assumes the following things:

* You'll be using a model named `sudokusolver` (`app/models/sudokusolver.rb`), whose class is `SudokusolverModel`. So it adds a `require` statement for that.
* You'll be using a view named `sudokusolver` (`app/views/sudokusolver.rb`), whose class is `SudokusolverView`. So it adds a `require` statement for that, **AND** it calls the `load` procedure of that view (`SudokusolverView.load`) at its `main` procedure.

That's how it should be following the conventions, but usually you won't really agree with that view if you're doing a big application. So you can just change everything refering to `sudokusolver` and `SudokusolverView` to `intro` and `IntroView`, to match the example above.

Of course, another convention thing is that its class is named `SudokusolverController` and it has a `main` method calling the view. You shouldn't change that.

There's also some code to let you add variables, as explained in the section above.

### Putting everything to work ###
As said above, you already have lots of `require`s in order to be able to use the model, control and view methods at all the generated files. But, that does nothing! 

Indeed. You just have to do an extra step that has to be done manually. Not because of developer's lazyness, but because RMVC is simple and usually won't do anything you don't expect to.

It's as easy as linking to the controller at your main file (if your project is `sudoku`, say `sudoku.rb`). 

```ruby
require `./app/controllers/sudokusolver_controller`
```

**Important!** The `./` before *app* is very important, don't ignore it! Also, don't add a `.rb` extension to the file, that's how require wants it!

Now you have access to all the controller, model and view's methods from your main/executable file. But usually all what you want to do is call the `main` method of the controller, so all what you would do is:

```ruby
SudokusolverController.main
```

Then add all the desired code under the controller, views and models. And you're done!




