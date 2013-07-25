require './app/models/hallo'

require './app/views/hallo'

class HalloController

  class << self
    #Add your variables here!

    attr_accessor :name

  end

  @name = "James!"

  def self.main

     HalloView.load

  end

end
