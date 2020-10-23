class Contestant
  attr_reader :full_name,
              :age,
              :state_of_residence,
              :game_interests
  
  attr_accessor :spending_money

  def initialize(info)
    @full_name = info[:first_name] + " " + info[:last_name]
    @age = info[:age]
    @state_of_residence = info[:state_of_residence]
    @spending_money = info[:spending_money]
    @game_interests = []
  end

  def out_of_state?
    @state_of_residence != "CO" ? true : false
  end

  def add_game_interest(game)
    @game_interests << game
  end
end