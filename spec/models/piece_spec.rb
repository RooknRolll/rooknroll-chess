require 'rails_helper'

RSpec.describe Piece, type: :model do
  describe 'is_obstructed method' do
    before(:each) do
      @game = create(:game)
      @game.pieces.destroy_all
      @queen = create(:queen, game_id: @game.id)
    end
    it 'raises an error when the move destination is off the board' do
      expect { @queen.is_obstructed?(8, 2) }.to raise_error(
        StandardError, 'The given coordinates are not on the board')
    end

    it 'raises an error when called for a move that is not linear' do
      expect { @queen.is_obstructed?(3, 4) }.to raise_error(
        StandardError, 'This move is not a valid move for this method to check')
    end

    it 'returns false when an unobstructed horizontal move is made' do
      expect(@queen.is_obstructed?(6, 2)).to eq false
    end

    it 'returns false when an unobstructed vertical move is made' do
      expect(@queen.is_obstructed?(2, 6)).to eq false
    end

    it 'returns false when an unobstructed diagonal move is made' do
      expect(@queen.is_obstructed?(7, 7)).to eq false 
    end

    it 'returns true when an obstructed horizontal move is made' do
      create(:pawn, x_coordinate: 4, game_id: @game.id)
      expect(@queen.is_obstructed?(6, 2)).to eq true
    end

    it 'returns true when an obstructed vertical move is made' do
      create(:pawn, y_coordinate: 4, game_id: @game.id)
      expect(@queen.is_obstructed?(2, 6)).to eq true
    end

    it 'returns true when an obstructed diagonal move is made' do
      create(:pawn, x_coordinate: 4, y_coordinate: 4, game_id: @game.id)
      expect(@queen.is_obstructed?(6, 6)).to eq true
    end

    it 'returns false if an unobstructed move attempts to capture a piece' do
      create(:pawn, x_coordinate: 6, y_coordinate: 6, game_id: @game.id)
      expect(@queen.is_obstructed?(6, 6)).to eq false
    end
  end
end
