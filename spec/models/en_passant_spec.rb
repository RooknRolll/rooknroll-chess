require 'rails_helper'

RSpec.describe EnPassant, type: :model do
  describe "when an en passant is captured" do
    before(:each) do
      @game = create(:game)
      black_player = @game.black_player
      @game.pieces.where(color: 'Black').update_all(player_id: black_player.id)
      @black_pawn = @game.pawns.find_by_coordinates(2, 6)
      @white_pawn = @game.pawns.find_by_coordinates(3, 1)
    end
    it 'destroys the associated pawn' do
      @white_pawn.update_attributes(y_coordinate: 4, moved: true)
      @game.update_attributes(turn: 1)
      @black_pawn.move(2, 4)
      @white_pawn.move(2, 5)
      expect(Piece.find_by_id(@black_pawn.id)).to be nil
    end
  end
end
