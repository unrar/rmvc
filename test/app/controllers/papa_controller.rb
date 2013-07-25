require './app/models/papa'
require './app/views/papa'
class PapaController
  class << self
    #Add your variables here!
    attr_accessor :name
  end
  @name = "James!"
  def self.main
     PapaView.load
  end
end
