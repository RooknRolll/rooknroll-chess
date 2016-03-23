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
      @king = create(:king, game_id: @game.id, y_coordinate: 0)
      @game.color_turn
      @white_player = @game.white_player
      @black_player = @game.black_player
      @game.player_turn
      @white_bishop = create(:bishop, game_id: @game.id, color: 'White', x_coordinate: 2, y_coordinate: 0)
      @black_bishop = create(:bishop, game_id: @game.id, color: 'Black', x_coordinate: 2, y_coordinate: 7)
    end
    it 'moves the piece to the correct place when move is valid' do
      @bishop.move(5, 5, @white_player)
      @bishop.reload
      expect(@bishop.x_coordinate).to eq 5
      expect(@bishop.y_coordinate).to eq 5
    end
    it 'does not move piece on an invalid move' do
      @bishop.move(4, 5, @white_player)
      @bishop.reload
      expect(@bishop.x_coordinate).to eq 2
      expect(@bishop.y_coordinate).to eq 2
    end
    it 'does not move if the move would put your king in check' do
      create(:queen, y_coordinate: 7, color: 'Black', game_id: @game.id)
      @bishop.move(5, 5, @white_player)
      @bishop.reload
      expect(@bishop.x_coordinate).to eq 2
      expect(@bishop.y_coordinate).to eq 2
    end
    it 'does not allow when you are in check and the proposed move would not get
        you out of check' do
      @king.update_attributes(x_coordinate: 3)
      create(:knight, x_coordinate: 4, y_coordinate: 2, game_id: @game.id,
                      color: 'Black')
      @bishop.move(5, 5, @white_player)
      @bishop.reload
      expect(@bishop.x_coordinate).to eq 2
      expect(@bishop.y_coordinate).to eq 2
    end

    it 'does not allow when you are in check and the proposed move would not get
        you out of check' do
      @king.update_attributes(x_coordinate: 3, color: 'White')
      @black_bishop.update_attributes(x_coordinate: 5, y_coordinate: 2)
      @white_bishop.update_attributes(x_coordinate: 3, y_coordinate: 2)      
      expect(@white_bishop.move(2, 3, @white_player)).to eq false
    end

    it 'changes the moved attribute to true' do
      @bishop.move(5, 5, @white_player)
      @bishop.reload
      expect(@bishop.moved).to be true
    end

    it 'accepts castling as a valid move' do
      @game.pieces.destroy_all
      @king = create(:king, game_id: @game.id, x_coordinate: 3, y_coordinate: 0)
      @rook = create(:rook, game_id: @game.id, x_coordinate: 7, y_coordinate: 0)
      @king.move(7, 0, @white_player)
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
      @white_pawn.move(3, 3, @white_player)
      @black_knight.move(2, 5, @black_player)
      expect(@game.en_passants).to be_empty
    end

    it 'increments turn by 1 on a successful move' do
      @bishop.move(5, 5, @white_player)
      expect(@game.reload.turn).to eq 1
    end

    it 'does not increment turn on an unsuccessful move' do
      @pawn = create(:pawn, x_coordinate: 3, y_coordinate: 1, game_id: @game.id)
      @pawn.move(3, 1, @white_player)
      expect(@game.reload.turn).to eq 0
    end

    it 'returns false if correct_turn? is false' do
      @black_player = @game.black_player
      @white_bishop = @game.pieces.find_by_coordinates(2, 0)
      expect(@white_bishop.move(3, 1, @black_player)).to eq false
    end

    it 'returns true if correct_turn? is true and other move conditions are true' do
      @white_player = @game.white_player
      @white_bishop = @game.pieces.find_by_coordinates(2, 0)
      expect(@white_bishop.move(3, 1, @white_player)).to eq true
    end
  end

  describe 'capturing another piece' do
    before(:each) do
      @game = create(:game)
      @game.pieces.destroy_all
      @white_bishop = create(:bishop, game_id: @game.id, color: 'White', x_coordinate: 4, y_coordinate: 4)
      create(:king, game_id: @game.id, y_coordinate: 0)
      @pawn = create(:pawn, color: 'Black', game_id: @game.id, x_coordinate: 5, y_coordinate: 5)
    end
    
    it 'removes the captured piece' do
      pawn_id = @pawn.id
      @white_bishop.move(5, 5, @white_player)
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
      @black_queen.move(3, 6, @black_player)
      expect(@white_king.move_into_check?(2,0)).to be false
    end

    it 'returns true when moving a non-king piece would put your king in check' do
      @white_queen.update_attributes(x_coordinate: 3, y_coordinate: 1)
      @black_queen.update_attributes(x_coordinate: 3, y_coordinate: 6)
      expect(@white_queen.move_into_check?(4,1)).to be true
    end

    it 'returns false when capturing a piece that had your king in check' do
      @white_queen.move(3, 1, @white_player)
      @black_queen.move(3, 6, @black_player)
      expect(@white_queen.move_into_check?(3, 6)).to be false
    end

    it 'returns true when performing an en passant would put your king in check' do
      white_pawn = create(:pawn, x_coordinate: 3, y_coordinate: 1, game_id: @game.id)
      black_pawn = create(:pawn, x_coordinate: 4, y_coordinate: 3, moved: true, color: 'Black', game_id: @game.id)
      @black_king.update_attributes(x_coordinate: 0, y_coordinate: 0)
      @black_queen.update_attributes(x_coordinate: 0, y_coordinate: 3)
      @white_queen.update_attributes(x_coordinate: 5, y_coordinate: 5)
      @white_king.update_attributes(x_coordinate: 6, y_coordinate: 5)

      white_pawn.move(3, 3, @white_player)
      expect(black_pawn.move_into_check?(3, 2)).to be true
    end

    it 'returns true when you are in check and the proposed move does not get
        you out of check' do
      create(:knight, x_coordinate: 2, y_coordinate: 5, game_id: @game.id)
      expect(@black_queen.move_into_check?(4, 6)).to be true
    end
  end

  describe 'piece_turn? method' do
    before(:each) do     
      @game = create(:game)
    end

    it 'should return true if color_turn? is White and piece color is White' do
      @white_pawn = @game.pieces.find_by_coordinates(0, 1)
      expect(@white_pawn.piece_turn?).to eq true
    end

    it 'should return false if the color_turn? is White and the piece color is Black' do
      @black_pawn = @game.pieces.find_by_coordinates(0, 6)
      expect(@black_pawn.piece_turn?).to eq false
    end
  end

  describe 'correct_player? method' do
    before(:each) do     
      @game = create(:game)
      @game.color_turn
      @white_player = @game.white_player
      @black_player = @game.black_player
      @game.player_turn
      @white_pawn = @game.pieces.find_by_coordinates(0, 1)
    end

    it 'should return true if the player equals player_turn' do
      expect(@white_pawn.correct_player?(@white_player)).to eq true
    end

    it 'should return false if the player does not equal player_turn' do
      expect(@white_pawn.correct_player?(@black_player)).to eq false
    end
  end

  describe 'correct_turn? method' do
    before(:each) do     
      @game = create(:game)
      @game.color_turn
      @white_player = @game.white_player
      @black_player = @game.black_player
      @game.player_turn
      @white_pawn = @game.pieces.find_by_coordinates(0, 1)
      @black_pawn = @game.pieces.find_by_coordinates(0, 6)
    end

    it 'should return true if piece_turn? and correct_player? are true' do
      expect(@white_pawn.correct_turn?(@white_player)).to eq true
    end

    it 'should return false if piece_turn? is false' do
      expect(@black_pawn.correct_turn?(@white_player)).to eq false
    end

    it 'should return false if correct_player? is false' do
      expect(@white_pawn.correct_turn?(@black_player)).to eq false
    end
  end
end
