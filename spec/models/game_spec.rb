require 'rails_helper'

RSpec.describe Game, type: :model do
  describe ".with_open_seats" do
    it "should return game with a missing player" do
      game2 = create(:game, black_player: nil)
      game3 = create(:game)

      expect(Game.with_open_seats).to eq([game2])
    end
  end

  describe "populate_board!" do
  	it "should populate all the pieces" do
  	  ng = create(:game)
      expect(ng.pieces.count).to eq(32)
  	end
  end

  describe "check?" do
    before(:each) do
      @game = create(:game)
      @game.pieces.destroy_all
      @king = create(:king, game_id: @game.id, x_coordinate: 4, y_coordinate: 0, color: 'White')
    end

    context 'Pawn' do
      it 'should return true if the opponent Pawn can capture the King' do
        @pawn = create(:pawn, game_id: @game.id, x_coordinate: 3, y_coordinate: 1, color: 'Black')
        expect(@game.check?(@king.color)).to eq true
      end
    end

    context 'Knight' do
      it 'should return true if the opponent Knight can capture the King' do
        @knight = create(:knight, game_id: @game.id, x_coordinate: 3, y_coordinate: 2, color: 'Black')
        expect(@game.check?(@king.color)).to eq true
      end
    end

    context 'Rook' do
      before(:each) do
        @rook = create(:rook, game_id: @game.id, x_coordinate: 4, y_coordinate: 2, color: 'Black')
      end

      it 'should return true if the opponent Rook can capture the King' do
        expect(@game.check?(@king.color)).to eq true
      end

      it 'should return false if the Rook is blocked by another piece' do
        @pawn = create(:pawn, game_id: @game.id, x_coordinate: 4, y_coordinate: 1, color: 'White')
        expect(@game.check?(@king.color)).to eq false
      end
    end

    context 'Bishop' do
      before(:each) do
        @bishop = create(:bishop, game_id: @game.id, x_coordinate: 2, y_coordinate: 2, color: 'Black')
      end

      it 'should return true if the opponent Bishop can capture the King' do
        expect(@game.check?(@king.color)).to eq true
      end

      it 'should return false if the Bishop is blocked by another piece' do
        @pawn = create(:pawn, game_id: @game.id, x_coordinate: 3, y_coordinate: 1, color: 'White')
        expect(@game.check?(@king.color)).to eq false
      end
    end

    context 'Queen' do
      before(:each) do
        @queen = create(:queen, game_id: @game.id, x_coordinate: 2, y_coordinate: 2, color: 'Black')
      end

      it 'should return true if the opponent Queen can capture the King' do
        expect(@game.check?(@king.color)).to eq true
      end

      it 'should return false if the Queen is blocked by another piece' do
        @pawn = create(:pawn, game_id: @game.id, x_coordinate: 3, y_coordinate: 1, color: 'White')
        expect(@game.check?(@king.color)).to eq false
      end
    end
  end

  describe 'color_turn method' do
    before(:each) do
      @game = create(:game)
    end

    it 'should return White if the turn column is 0' do
      expect(@game.color_turn).to eq 'White'
    end

    it 'should return Black if the turn column is an odd value' do
      @game.update_attributes(turn: 1)
      expect(@game.color_turn).to eq 'Black'
    end

    it 'should return White if the turn column is an even value' do
      @game.update_attributes(turn: 4)
      expect(@game.color_turn).to eq 'White'
    end
  end

  describe 'player_turn method' do
    before(:each) do
      @game = create(:game)
    end

    it 'should return white_player if color_turn is White' do
      @game.color_turn
      @white_player = @game.white_player
      @black_player = @game.black_player
      expect(@game.player_turn).to eq @white_player
    end
  end

  describe 'player_has_valid_moves' do
    before(:each) do
      @game = create(:game)
      @game.pieces.destroy_all
      @white_king = create(:king, game_id: @game.id, x_coordinate: 0, y_coordinate: 0)
      @black_king = create(:king, game_id: @game.id, x_coordinate: 7, y_coordinate: 7, color:'Black')
    end

    it 'returns false when a player has no valid moves' do
      create(:rook, game_id: @game.id, x_coordinate: 1, y_coordinate: 6, color: 'Black')
      create(:rook, game_id: @game.id, x_coordinate: 6, y_coordinate: 1, color: 'Black')
      expect(@game.player_has_valid_moves?('White')).to be false
    end

    it 'returns true when a player has valid moves' do
      create(:rook, game_id: @game.id, x_coordinate: 1, y_coordinate: 6, color: 'Black')
      expect(@game.player_has_valid_moves?('White')).to be true
    end
  end

  describe 'player_in_checkmate' do
    before(:each) do
      @game = create(:game)
      @white_queen = @game.pieces.find_by(type: 'Queen', color: 'White')
      @white_bishop = @game.pieces.find_by_coordinates(2, 0)
      @white_queen.update_attributes(x_coordinate: 0, y_coordinate: 4)
    end

    it 'returns false when the player is not in check' do
      expect(@game.player_in_checkmate?('Black')).to be false
    end

    it 'returns false when the player is in check but can get out of check' do
      black_knight = @game.pieces.find_by_coordinates(1, 7)
      black_knight.move(0, 5)
      @white_queen.move(2, 6)
      expect(@game.player_in_checkmate?('Black')).to be false
    end

    it 'returns true when the player is in checkmate' do
      @white_bishop.update_attributes(x_coordinate: 5, y_coordinate: 3)
      @white_queen.move(2, 6)
      expect(@game.player_in_checkmate?('Black')).to be true
    end
    context "when checkmate occurs" do
      before(:each) do
        @white_bishop.update_attributes(x_coordinate: 5, y_coordinate: 3)
        @white_queen.move(2, 6)
      end
      it 'increments the winning players win column' do
        @game.player_in_checkmate?('Black')
        expect(@game.white_player.wins).to eq 1
      end

      it 'increments the losing players losses column' do
        @game.player_in_checkmate?('Black')
        expect(@game.black_player.losses).to eq 1
      end

      it 'sets the game.game_over to true when in checkmate' do
        @game.player_in_checkmate?('Black')
        @game.reload
        expect(@game.game_over).to be true
      end

      it 'does not increment the players win/losses more than once per game' do
        @game.player_in_checkmate?('Black')
        @game.player_in_checkmate?('Black')
        expect(@game.white_player.wins).to eq 1
      end
    end
  end

  describe 'stalemate? method' do
    before(:each) do
      @game = create(:game)
      @game.pieces.destroy_all
      @white_player = @game.white_player
      @black_player = @game.black_player
      @white_king = create(:king, game_id: @game.id, x_coordinate: 7, y_coordinate: 7, color: 'White')
      @black_queen = create(:queen, game_id: @game.id, x_coordinate: 7, y_coordinate: 6, color: 'Black')
    end

    it 'should return false if players still have valid moves' do
      @game.player_has_valid_moves?('White')
      expect(@game.stalemate?('White')).to eq false
    end

    it 'should return false if the players king is in check' do
      # white king is in check and it is black turn
      @game.update_attributes(turn: 5)
      expect(@game.stalemate?('White')).to eq false
    end

    it 'should return true if not in check but has no valid moves' do
      @black_queen.update_attributes(x_coordinate: 6, y_coordinate: 5)
      expect(@game.stalemate?('White')).to eq true
    end

    it 'should return false if it is not the color pieces turn' do
      @black_queen.update_attributes(x_coordinate: 6, y_coordinate: 5)
      @game.update_attributes(turn: 1)
      expect(@game.stalemate?('White')).to eq false
    end
  end

  describe 'over_by_stalemate method' do
    before(:each) do
      @game = create(:game)
      @game.pieces.destroy_all
      @white_player = @game.white_player
      @black_player = @game.black_player
      @white_king = create(:king, game_id: @game.id, x_coordinate: 7, y_coordinate: 7, color: 'White')
      @black_queen = create(:queen, game_id: @game.id, x_coordinate: 6, y_coordinate: 5, color: 'Black')
    end

    it "should increment the player stalemate column" do
      @game.over_by_stalemate('White')
      expect(@white_player.stalemates).to eq 1
    end

    it 'should make the game over column turn true' do
      @game.over_by_stalemate('White')
      expect(@game.game_over).to eq true
    end

    it 'should not make a game over if stalemate? is false' do
      @black_queen.update_attributes(x_coordinate: 6, y_coordinate: 5)
      @game.update_attributes(turn: 1)
      @game.over_by_stalemate('White')
      expect(@game.game_over).to eq false
    end
  end

  describe 'increment_stalemate method' do
    it 'should increment black_player and white_player stalemates' do
      @game = create(:game)
      @white_player = @game.white_player
      @black_player = @game.black_player
      @game.increment_stalemate
      expect(@white_player.stalemates && @black_player.stalemates).to eq 1
    end
  end
end
