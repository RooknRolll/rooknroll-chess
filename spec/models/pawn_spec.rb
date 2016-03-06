require 'rails_helper'

RSpec.describe Pawn, type: :model do
  describe 'valid_move?' do
    before(:each) do
      @game = create(:game)
      @game.pieces.destroy_all
      @pawn = create(:pawn, game_id: @game.id, x_coordinate: 0, y_coordinate: 1, color: 'White')
    end

    context 'an invalid move' do
      it 'raises an error when the move is off the board' do
        expect { @pawn.valid_move?(8, 2) }.to raise_error(
          StandardError, 'The given coordinates are not on the board')
      end

      it 'returns false when the destination is the same place' do
        expect(@pawn.valid_move?(0, 1)).to eq(false)
      end

      it 'returns false if a same color piece is in the destination' do
        create(:knight, x_coordinate: 0, y_coordinate: 2, game_id: @game.id, color: 'White')
        expect(@pawn.valid_move?(0, 2)).to eq(false)
      end

      it 'returns false for a move 1 right, 0 forward' do
        expect(@pawn.valid_move?(1, 1)).to eq(false)
      end

      it 'returns false for a move backwards' do
        expect(@pawn.valid_move?(0, 0)).to eq(false)
      end

      it 'returns false for a move forward 2 spaces when not the first move' do
        @pawn.y_coordinate = 2
        expect(@pawn.valid_move?(0, 4)).to eq(false)
      end

      it 'returns false for a move forward 3 spaces' do
        @pawn.y_coordinate = 2
        expect(@pawn.valid_move?(0, 5)).to eq(false)
      end
    end

    context 'a valid move' do
      it 'returns true for a move 1 space forward' do
        expect(@pawn.valid_move?(0, 2)).to eq(true)
      end

      it 'returns true for a first move 2 spaces forward' do
        expect(@pawn.valid_move?(0, 3)).to eq(true)
      end

      it 'returns true for a 1 forward, diagonal move to an opponent space' do
        create(:knight, x_coordinate: 1, y_coordinate: 2, color: 'Black')
        expect(@pawn.valid_move?(1, 2))
      end
    end
  end
end