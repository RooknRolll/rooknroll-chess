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

  describe "move method" do
    before(:each) do
      @game = create(:game)
      @game.pieces.destroy_all
      @bishop = create(:bishop, game_id: @game.id)
    end
    it 'moves the piece to the correct place when move is valid' do
      @bishop.move(5, 5)
      @bishop.reload
      expect(@bishop.x_coordinate).to eq 5
      expect(@bishop.y_coordinate).to eq 5
    end
    it 'does not move piece on an invalid move' do
      @bishop.move(4, 5)
      @bishop.reload
      expect(@bishop.x_coordinate).to eq 2
      expect(@bishop.y_coordinate).to eq 2
    end

    it 'changes the moved attribute to true' do
      @bishop.move(5, 5)
      @bishop.reload
      expect(@bishop.moved).to be true
    end

    it 'accepts castling as a valid move' do
      @game.pieces.destroy_all
      @king = create(:king, game_id: @game.id, x_coordinate: 3, y_coordinate: 0)
      @rook = create(:rook, game_id: @game.id, x_coordinate: 7, y_coordinate: 0)
      @king.move(7, 0)
      @king.reload
      @rook.reload
      expect(@king.x_coordinate).to eq 5
      expect(@rook.x_coordinate).to eq 4
    end

    it 'destroys all en passants of the opposite color so that en passants are \
        only valid for one turn' do
      @game = create(:game)
      @white_pawn = @game.pieces.find_by_coordinates(3, 1)
      @black_knight = @game.pieces.find_by_coordinates(1, 7)
      @white_pawn.move(3, 3)
      @black_knight.move(2, 5)
      expect(@game.en_passants).to be_empty
    end
  end


  describe 'capturing another piece' do
    before(:each) do
      @game = create(:game)
      @game.pieces.destroy_all
      @bishop = create(:bishop, game_id: @game.id)
      @pawn = create(:pawn, color: 'Black', game_id: @game.id, x_coordinate: 5, y_coordinate: 5)
    end
    it 'removes the captured piece' do
      pawn_id = @pawn.id

      @bishop.move(5, 5)
      expect(Piece.find_by_id(pawn_id)).to be_nil
    end
  end
end
