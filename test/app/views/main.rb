require './app/controllers/default_controller'
class MainView
  def self.load
    puts "Hello, hello #{DefaultController.name}!"
  end
end
