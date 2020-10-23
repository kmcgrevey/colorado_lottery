require_relative '../lib/contestant'
require_relative '../lib/game'
require_relative '../lib/colorado_lottery'
require 'pry'

RSpec.describe "Colorado Lottery" do
  before(:each) do
    @lottery = ColoradoLottery.new
    
    @pick_4 = Game.new('Pick 4', 2)
    @mega_millions = Game.new('Mega Millions', 5, true)
    @cash_5 = Game.new('Cash 5', 1)

    @alexander = Contestant.new({
                       first_name: 'Alexander',
                       last_name: 'Aigades',
                       age: 28,
                       state_of_residence: 'CO',
                       spending_money: 10})
    @benjamin = Contestant.new({
                       first_name: 'Benjamin',
                       last_name: 'Franklin',
                       age: 17,
                       state_of_residence: 'PA',
                       spending_money: 100})
    @frederick = Contestant.new({
                       first_name:  'Frederick',
                       last_name: 'Douglas',
                       age: 55,
                       state_of_residence: 'NY',
                       spending_money: 20})
    @winston = Contestant.new({
                     first_name: 'Winston',
                     last_name: 'Churchill',
                     age: 18,
                     state_of_residence: 'CO',
                     spending_money: 5})
    @grace = Contestant.new({
                     first_name: 'Grace',
                     last_name: 'Hopper',
                     age: 20,
                     state_of_residence: 'CO',
                     spending_money: 20})
    
    @alexander.add_game_interest('Pick 4')
    @alexander.add_game_interest('Mega Millions')
    @frederick.add_game_interest('Mega Millions')
    @winston.add_game_interest('Cash 5')
    @winston.add_game_interest('Mega Millions')
    @benjamin.add_game_interest('Mega Millions')
    @grace.add_game_interest('Mega Millions')
    @grace.add_game_interest('Cash 5')
    @grace.add_game_interest('Pick 4')
  end

  it "has attributes" do
    expect(@lottery.registered_contestants).to eq({})
    expect(@lottery.winners).to eq([])
    expect(@lottery.current_contestants).to eq({})
  end

  it "contestant interested and 18" do
    expect(@lottery.interested_and_18?(@alexander, @pick_4)).to be(true)
    expect(@lottery.interested_and_18?(@benjamin, @mega_millions)).to be(false)
    expect(@lottery.interested_and_18?(@alexander, @cash_5)).to be(false)
  end
  
  it "contestant can register" do
    expect(@lottery.can_register?(@alexander, @pick_4)).to be(true)
    expect(@lottery.can_register?(@alexander, @cash_5)).to be(false)
    expect(@lottery.can_register?(@frederick, @mega_millions)).to be(true)
    expect(@lottery.can_register?(@benjamin, @mega_millions)).to be(false)
    expect(@lottery.can_register?(@frederick, @cash_5)).to be(false)
  end

  it "register contestants" do
    @lottery.register_contestant(@alexander, @pick_4)
    
    expect(@lottery.registered_contestants).to eq({"Pick 4"=> [@alexander]})

    @lottery.register_contestant(@alexander, @mega_millions)

    expect(@lottery.registered_contestants).to eq({"Pick 4"=> [@alexander], "Mega Millions"=> [@alexander]})

    @lottery.register_contestant(@frederick, @mega_millions)
    @lottery.register_contestant(@winston, @cash_5)
    @lottery.register_contestant(@winston, @mega_millions)

    expect(@lottery.registered_contestants).to eq({"Pick 4"=> [@alexander],
                                                   "Mega Millions"=> [@alexander, @frederick, @winston],
                                                   "Cash 5"=> [@winston]})

    @lottery.register_contestant(@grace, @mega_millions)
    @lottery.register_contestant(@grace, @cash_5)
    @lottery.register_contestant(@grace, @pick_4)

    expect(@lottery.registered_contestants).to eq({"Pick 4"=> [@alexander, @grace],
                                                   "Mega Millions"=> [@alexander, @frederick, @winston, @grace],
                                                   "Cash 5"=> [@winston, @grace]})

    # eligible contestants
    expect(@lottery.eligible_contestants(@pick_4)).to eq([@alexander, @grace])
    expect(@lottery.eligible_contestants(@cash_5)).to eq([@winston, @grace])
    expect(@lottery.eligible_contestants(@mega_millions)).to eq([@alexander, @frederick, @grace])

    # charge contestant adds them to current contestant list and docks funds
    @lottery.charge_contestants(@cash_5)
    
    expect(@lottery.current_contestants).to eq({@cash_5 => ["Winston Churchill", "Grace Hopper"]})
    expect(@grace.spending_money).to eq(19)
    expect(@winston.spending_money).to eq(4)

    @lottery.charge_contestants(@mega_millions)

    expect(@lottery.current_contestants).to eq(
              {@cash_5 => ["Winston Churchill", "Grace Hopper"],
               @mega_millions => ["Alexander Aigades", "Frederick Douglas", "Grace Hopper"]}
               )
    expect(@grace.spending_money).to eq(14)
    expect(@winston.spending_money).to eq(4)
    expect(@alexander.spending_money).to eq(5)
    expect(@frederick.spending_money).to eq(15)

    @lottery.charge_contestants(@pick_4)

    expect(@lottery.current_contestants).to eq(
              {@cash_5 => ["Winston Churchill", "Grace Hopper"],
               @mega_millions => ["Alexander Aigades", "Frederick Douglas", "Grace Hopper"],
               @pick_4 => ["Alexander Aigades", "Grace Hopper"]}
               )
  end
end
