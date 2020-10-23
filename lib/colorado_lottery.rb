class ColoradoLottery
  attr_reader :registered_contestants,
              :current_contestants,
              :winners
              
  def initialize
    @registered_contestants = {}
    @current_contestants = {}
    @winners = []
    @eligible_contestants = {}
    @drawing_date = nil
  end

  def interested_and_18?(contestant, game)
    if contestant.game_interests.include?(game.name) && (contestant.age >= 18)
      true
    else
      false
    end
  end

  def can_register?(contestant, game)
    if self.interested_and_18?(contestant, game)
      if !game.national_drawing
        !contestant.out_of_state? ? true : false
      else
        true
      end
    else
      false
    end
  end

  def register_contestant(contestant, game)
    if self.can_register?(contestant, game)
      if @registered_contestants[game.name]
        @registered_contestants[game.name] << contestant
      else
        @registered_contestants[game.name] = [contestant]
      end
    end
  end

  def eligible_contestants(game)
    good = @registered_contestants[game.name].find_all do |player|
             player.spending_money > game.cost
           end

    @eligible_contestants[game] = good
  end

  def charge_contestants(game)
    players = []
    @eligible_contestants[game].each do |player|
      player.spending_money -= game.cost
      players << player.full_name
    end
    @current_contestants[game] = players
  end

  def draw_winners
    @drawing_date = Time.now
    current_contestants.keys.each do |game|
      winners << {current_contestants[game][0] => game.name}
    end
    @drawing_date.strftime("%F")
  end
  
  def announce_winner(game)
    winner = winners.find { |winner| winner.values.first == game }
    
    "#{winner.keys.first} won the #{game} on #{drawing_date.strftime("%m/%d")}"
  end
end