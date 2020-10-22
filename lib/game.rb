class Game
  attr_reader :name,
              :cost,
              :national_drawing
              
  def initialize(name, cost, natl = false)
    @name = name
    @cost = cost
    @national_drawing = natl
  end

end