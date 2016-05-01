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

  describe 'can_move_to?' do
    before(:all) do
      @rook = Rook.create(x_coordinate: 3, y_coordinate: 3)
    end

    it 'returns true for horizontal moves' do
      expect(@rook.can_move_to?(0, 3)).to be true
      expect(@rook.can_move_to?(7, 3)).to be true
      expect(@rook.can_move_to?(2, 3)).to be true
      expect(@rook.can_move_to?(4, 3)).to be true
    end

    it 'returns true for vertical moves' do
      expect(@rook.can_move_to?(3, 2)).to be true
      expect(@rook.can_move_to?(3, 4)).to be true
      expect(@rook.can_move_to?(3, 0)).to be true
      expect(@rook.can_move_to?(3, 7)).to be true
    end

    it 'returns false for non horizontal or vertical moves' do
      expect(@rook.can_move_to?(2, 2)).to be false
      expect(@rook.can_move_to?(8, 7)).to be false
      expect(@rook.can_move_to?(5, 2)).to be false
      expect(@rook.can_move_to?(0, 6)).to be false
    end

    it 'returns false for moves off the board' do
      expect(@rook.can_move_to?(3, 8)).to eq false
      expect(@rook.can_move_to?(-1, 3)).to eq false
    end

    it 'returns false for non-moves' do
      expect(@rook.can_move_to?(3, 3)).to eq false
    end
  end
end
