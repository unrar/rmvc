require './app/models/ahoj'

require './app/views/ahoj'

class AhojController

  class << self
    #Add your variables here!

    attr_accessor :name

  end

  @name = "James!"

  def self.main

     AhojView.load

  end

end
