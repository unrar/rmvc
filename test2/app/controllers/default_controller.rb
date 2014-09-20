require './app/models/default'
require './app/views/main'
class DefaultController
  class << self
    #Add your variables here!
    attr_accessor :name
  end
  @name = "James!"
  def self.main
    MainView.load
  end
end
