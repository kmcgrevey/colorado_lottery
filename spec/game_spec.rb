require_relative '../lib/game'
require_relative '../lib/contestant'

RSpec.describe "Game" do
  before(:each) do
    @pick_4 = Game.new('Pick 4', 2)
    @mega_millions = Game.new('Mega Millions', 5, true)
  end

  it "exists" do
    expect(@pick_4).to be
    expect(@mega_millions).to be
  end

  it "has attributes" do
    expect(@mega_millions.name).to eq("Mega Millions")
    expect(@mega_millions.cost).to eq(5)
    expect(@mega_millions.national_drawing).to eq(true)
    expect(@pick_4.national_drawing).to eq(false)
  end
end
