require './app/models/love'

require './app/views/love'

class LoveController

  class << self
    #Add your variables here!

    attr_accessor :name

  end

  @name = "James!"

  def self.main

     LoveView.load

  end

end
