require 'rails_helper'

RSpec.describe Knight, type: :model do
  describe 'valid_move?' do    
    before(:each) do
      @game = create(:game)
      @game.pieces.destroy_all
      @knight = create(:knight, game_id: @game.id, x_coordinate: 1, y_coordinate: 0)
    end

    context 'an invalid move' do
      it 'raises an error when the move is off the board' do
        expect { @knight.valid_move?(8, 2) }.to raise_error(
          StandardError, 'The given coordinates are not on the board')
      end

      it 'returns false when the destination is the same place' do
        expect(@knight.valid_move?(1, 0)).to eq(false)
      end

      it 'returns false if a same color piece is in the destination' do
        create(:pawn, x_coordinate: 0, y_coordinate: 2, game_id: @game.id)
        expect(@knight.valid_move?(0, 2)).to eq(false)
      end
    end

    context 'a valid move' do
      it 'returns true for a move 1 left, 2 down to an unoccupied space' do
        expect(@knight.valid_move?(0, 2)).to eq(true)
      end

      it 'returns true for a move 1 right, 2 down to an unoccupied space' do
        expect(@knight.valid_move?(2, 2)).to eq(true)
      end

      it 'returns true for a move 2 right, 1 down to an unoccupied space' do
        expect(@knight.valid_move?(3, 1)).to eq(true)
      end

      it 'returns true when it moves to a space with an opponent piece' do
        create(:pawn, x_coordinate: 0, y_coordinate: 2, color: 'Black',
                    game_id: @game.id)
        expect(@knight.valid_move?(0, 2)).to eq(true)
      end
    end
  end
end
