require 'rails_helper'

RSpec.describe Bishop, type: :model do
  describe 'valid_move?' do
    before(:each) do
      @game = create(:game)
      @game.pieces.destroy_all
      @bishop = create(:bishop, x_coordinate: 2, y_coordinate: 7,
                                game_id: @game.id)
    end
    it 'returns false for a proposed move that is off the board' do
      expect { @bishop.valid_move?(1, 8) }.to raise_error(
        StandardError, 'The given coordinates are not on the board')
    end

    it 'returns false when proposed move is to where piece already is' do
      expect(@bishop.valid_move?(2, 7)).to eq false
    end

    it 'returns false when the move is obstructed by another piece' do
      create(:pawn, x_coordinate: 3, y_coordinate: 6, game_id: @game.id)
      expect(@bishop.valid_move?(4, 5)).to eq false
    end

    it 'returns false for unobstructed move to a space that contains a piece of
        the same color' do
      create(:pawn, x_coordinate: 3, y_coordinate: 6, game_id: @game.id)
      expect(@bishop.valid_move?(3, 6)).to eq false
    end

    it 'returns false for move that is not diagonal' do
      expect(@bishop.valid_move?(2, 5)).to eq false
      expect(@bishop.valid_move?(3, 5)).to eq false
    end

    it 'returns true for unobstructed moves to an empty space' do
      expect(@bishop.valid_move?(4, 5)).to eq true
    end

    it 'returns true when unobstructed move is to a space that contains a piece
        of the opposite color' do
      create(:pawn, x_coordinate: 0, y_coordinate: 5, color: 'Black',
                    game_id: @game.id)
      expect(@bishop.valid_move?(0, 5)).to eq true
    end
  end
end
