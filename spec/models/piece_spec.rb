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
      create(:king, game_id: @game.id, y_coordinate: 0)
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
    it 'does not move if the move would put your king in check' do
      create(:queen, y_coordinate: 7, color: 'Black', game_id: @game.id)
      @bishop.move(5, 5)
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

    it 'increments the turn column by 1 on a successful move' do
      @bishop.move(5, 5)
      @game.reload
      expect(@game.turn).to eq 1
    end
  end


  describe 'capturing another piece' do
    before(:each) do
      @game = create(:game)
      @game.pieces.destroy_all
      @bishop = create(:bishop, game_id: @game.id)
      create(:king, game_id: @game.id, y_coordinate: 0)
      @pawn = create(:pawn, color: 'Black', game_id: @game.id, x_coordinate: 5, y_coordinate: 5)
    end
    it 'removes the captured piece' do
      pawn_id = @pawn.id

      @bishop.move(5, 5)
      expect(Piece.find_by_id(pawn_id)).to be_nil
    end
  end

  describe '#move_into_check?' do
    before(:each) do
      @game = create(:game)
      @game.pieces.destroy_all
      @white_king = create(:king, x_coordinate: 3, y_coordinate: 0, game_id: @game.id)
      @white_queen = create(:queen, x_coordinate: 4, y_coordinate: 0, game_id: @game.id)
      @black_king = create(:king, x_coordinate: 3, y_coordinate: 7, color: 'Black', game_id: @game.id)
      @black_queen = create(:queen, x_coordinate: 4, y_coordinate: 7, color: 'Black', game_id: @game.id)
    end

    it 'returns true when moving the king into check' do
      expect(@white_king.move_into_check?(4,1)).to be true
      expect(@black_king.move_into_check?(4,6)).to be true
    end

    it 'returns false when a king is moving out of check' do
      @black_queen.move(3, 6)
      expect(@white_king.move_into_check?(2,0)).to be false
    end

    it 'returns true when moving a non-king piece would put your king in check' do
      @white_queen.move(3, 1)
      @black_queen.move(3, 6)
      expect(@white_queen.move_into_check?(4,1)).to be true
    end

    it 'returns false when capturing a piece that had your king in check' do
      @white_queen.move(3, 1)
      @black_queen.move(3, 6)
      expect(@white_queen.move_into_check?(3, 6)).to be false
    end

    it 'returns true when performing an en passant would put your king in check' do
      white_pawn = create(:pawn, x_coordinate: 3, y_coordinate: 1, game_id: @game.id)
      black_pawn = create(:pawn, x_coordinate: 4, y_coordinate: 3, moved: true, color: 'Black', game_id: @game.id)
      @black_king.update_attributes(x_coordinate: 0, y_coordinate: 0)
      @black_queen.update_attributes(x_coordinate: 0, y_coordinate: 3)
      @white_queen.update_attributes(x_coordinate: 5, y_coordinate: 5)
      @white_king.update_attributes(x_coordinate: 6, y_coordinate: 5)

      white_pawn.move(3, 3)
      expect(black_pawn.move_into_check?(3, 2)).to be true
    end
  end
end
