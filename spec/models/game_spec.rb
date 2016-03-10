require 'rails_helper'

RSpec.describe Game, type: :model do
  describe ".with_open_seats" do
    it "should return game with a missing player" do
      game1 = create(:game, white_player: nil)
      game2 = create(:game, black_player: nil)
      game3 = create(:game)

      expect(Game.with_open_seats).to eq([game1, game2])
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
      end
    end

    context 'Knight' do
      it 'should return true if the opponent Knight can capture the King' do
        @knight = create(:knight, game_id: @game.id, x_coordinate: 3, y_coordinate: 2, color: 'Black')
      end
    end

    context 'Rook' do
      before(:each) do
        @rook = create(:rook, game_id: @game.id, x_coordinate: 4, y_coordinate: 2, color: 'Black')
      end

      it 'should return true if the opponent Rook can capture the King' do
      end

      it 'should return false if the Rook is blocked by another piece' do
        @pawn = create(:pawn, game_id: @game.id, x_coordinate: 4, y_coordinate: 1, color: 'White')
      end
    end

    context 'Bishop' do
      before(:each) do
        @bishop = create(:bishop, game_id: @game.id, x_coordinate: 2, y_coordinate: 2, color: 'Black')
      end

      it 'should return true if the opponent Bishop can capture the King' do
      end

      it 'should return false if the Bishop is blocked by another piece' do
        @pawn = create(:pawn, game_id: @game.id, x_coordinate: 3, y_coordinate: 1, color: 'White')
      end
    end

    context 'Queen' do
      before(:each) do
        @queen = create(:queen, game_id: @game.id, x_coordinate: 2, y_coordinate: 2, color: 'Black')
      end

      it 'should return true if the opponent Queen can capture the King' do
      end

      it 'should return false if the Queen is blocked by another piece' do
        @pawn = create(:pawn, game_id: @game.id, x_coordinate: 3, y_coordinate: 1, color: 'White')
      end
    end
  end
end
