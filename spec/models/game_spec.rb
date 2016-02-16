require 'rails_helper'

RSpec.describe Game, type: :model do
  describe ".with_open_seats" do
    it "should return game with a missing player" do
      game1 = create(:game, white_player: nil)
      game2 = create(:game, black_player: nil)
      game3 = create(:game)

      expect(Game.with_open_seats).to eq([game1, game2])
    end
  end
end
