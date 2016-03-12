require 'rails_helper'

RSpec.describe Rook, type: :model do
  describe 'valid_move?' do
  	before(:each) do
      @game = create(:game)
      @game.pieces.destroy_all
      @rook = create(:rook, x_coordinate: 2, y_coordinate: 2,
                                game_id: @game.id)
    end

    it 'returns false for a proposed move that is not parallel to boards edge' do
      expect(@rook.valid_move?(1, 3)).to be false
      expect(@rook.valid_move?(4, 4)).to be false
    end

    it 'returns false for move to spot piece already occupies' do
      expect(@rook.valid_move?(2, 2)).to eq false
  	end

  	it 'returns false when the move is obstructed by another piece' do
      create(:pawn, x_coordinate: 2, y_coordinate: 4, game_id: @game.id)
      expect(@rook.valid_move?(2, 5)).to eq false
    end

    it 'returns true when unobstructed move is to a space that contains a piece
        of the opposite color' do
      create(:pawn, x_coordinate: 2, y_coordinate: 4, color: 'Black',
                    game_id: @game.id)
      expect(@rook.valid_move?(2, 4)).to eq true
  	end

  	it 'returns false for a proposed move that is off the board' do
      expect { @rook.valid_move?(2, 8) }.to raise_error(
        StandardError, 'The given coordinates are not on the board')
    end
  end
end
