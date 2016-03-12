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

      it 'returns false for far away, non-linear moves' do
        expect(@pawn.valid_move?(2, 7)).to be false
      end

      it 'returns false if a same color piece is in the destination' do
        create(:knight, x_coordinate: 0, y_coordinate: 2, game_id: @game.id, color: 'White')
        expect(@pawn.valid_move?(0, 2)).to eq(false)
      end

      it 'returns false when attempting a vertical move to a space containing an opponent piece' do
        create(:knight, x_coordinate: 0, y_coordinate: 2, game_id: @game.id, color: 'Black')
        expect(@pawn.valid_move?(0, 2)).to eq(false)
      end

      it 'returns false when attempting a 2 space move over another piece' do
        create(:knight, x_coordinate: 0, y_coordinate: 2, game_id: @game.id, color: 'Black')
        expect(@pawn.valid_move?(0, 3)).to eq(false)
      end

      it 'returns false for a move 1 right, 0 forward' do
        expect(@pawn.valid_move?(1, 1)).to eq(false)
      end

      it 'returns false for a move backwards' do
        expect(@pawn.valid_move?(0, 0)).to eq(false)
      end

      it 'returns false for a move forward 2 spaces when not the first move' do
        @pawn.move(0, 2)
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
        create(:knight, x_coordinate: 1, y_coordinate: 2, color: 'Black', game_id: @game.id)
        expect(@pawn.valid_move?(1, 2)).to eq(true)
      end

      it 'returns true when capturing an en passant' do
        black_pawn = create(:pawn, color: 'Black',
                                   x_coordinate: 1,
                                   y_coordinate: 6,
                                   game_id: @game.id)

        @pawn.update_attributes(y_coordinate: 4, moved: true)
        black_pawn.move(1, 4)
        expect(@pawn.valid_move?(1, 5)).to be true
      end
    end
  end

  describe 'when a double forward move is made' do
    before(:each) do
      @game = create(:game)
      @pawn = @game.pawns.find_by_coordinates(2, 1)
    end
    it 'creates an en passant in the square behind the pawn' do
      @pawn.move(2, 3)
      expect(@pawn.en_passants.where(x_coordinate: 2, y_coordinate: 2).first)
        .not_to be nil
    end
  end

  describe 'when capturing' do
    before(:each) do
      @game = create(:game)
      @black_pawn = @game.pieces.find_by_coordinates(3, 6)
      @white_pawn = @game.pieces.find_by_coordinates(4, 1)
      @white_pawn.move(4, 3)
      @black_pawn.move(3, 4)
    end
    it 'moves the piece to the place where the capture occurs' do
      @black_pawn.move(4, 3)
      @black_pawn.reload
      expect(@game.pieces.find_by_coordinates(4, 3).id).to eq @black_pawn.id
    end

    it 'destroys the captured piece' do
      white_pawn_id = @white_pawn.id
      @black_pawn.move(4, 3)
      expect(Piece.find_by_id(white_pawn_id)).to be nil
    end
  end
end
