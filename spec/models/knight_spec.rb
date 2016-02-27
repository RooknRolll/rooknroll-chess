require 'rails_helper'

RSpec.describe Knight, type: :model do
  describe 'valid_move?' do    
    before(:each) do
      @game = create(:game)
      @game.pieces.destroy_all
      @queen = create(:queen, game_id: @game.id)
      @knight = create(:knight, game_id: @game.id, color: 'White', x_coordinate: 1, y_coordinate: 0)
    end

    context 'invalid move' do
      it 'raises an error when the move is off the board' do
        expect { @knight.valid_move?(8, 2) }.to raise_error(
          StandardError, 'The given coordinates are not on the board')
      end

      it 'is false if a same team piece is in the destination' do
        @queen.x_coordinate = 0
        @queen.y_coordinate = 2
        expect(@knight.valid_move?(0, 2)).to eq(false)
      end
    end

    context 'valid move' do
      it 'is true for a move 1 left, 2 down' do
        expect(@knight.valid_move?(0, 2)).to eq(true)
      end

      it 'is true for a move 1 right, 2 down' do
        expect(@knight.valid_move?(1, 2)).to eq(true)
      end

      it 'is true for a move 2 right, 1 down' do
        expect(@knight.valid_move?(3, 1)).to eq(true)
      end
    end
  end
end
