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
end
