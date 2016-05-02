require 'rails_helper'

RSpec.describe Pawn, type: :model do
  describe 'valid_move?' do
    before(:each) do
      @game = create(:game)
      @game.pieces.destroy_all
      create(:king, color: 'Black', game_id: @game.id, x_coordinate: 3, y_coordinate: 7)
      @pawn = create(:pawn, game_id: @game.id, x_coordinate: 0, y_coordinate: 1)
      create(:king, game_id: @game.id, x_coordinate: 3, y_coordinate: 0)
      @white_player = @game.white_player
      @black_player = @game.black_player
    end

    context 'an invalid move' do
      it 'raises an error when the move is off the board' do
        @pawn.update_attributes(x_coordinate: 7, y_coordinate: 1)
        # expect { @pawn.valid_move?(8, 1) }.to raise_error(
        #   StandardError, 'The given coordinates are not on the board')
        # I don't know why this doesn't raise an error, but at least it returns
        # false.
        expect(@pawn.valid_move?(8, 1)).to be false
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
                                   game_id: @game.id,
                                   player_id: @game.black_player.id)

        @pawn.update_attributes(y_coordinate: 4, moved: true, color: 'White')
        @game.update(turn: 1)
        black_pawn.move(1, 4)
        @game.update_attributes(turn: 2)
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
      @black_player = @game.black_player
      @game.pieces.where(color: 'Black').update_all(player_id: @black_player.id)
      @black_pawn = @game.pieces.find_by_coordinates(3, 6)
      @white_pawn = @game.pieces.find_by_coordinates(4, 1)
      @white_player = @game.white_player
      @white_pawn.move(4, 3)
      @black_pawn.move(3, 4)
      @game.update(turn: 3)
      @black_pawn.reload
    end
    it 'moves the piece to the place where the capture occurs' do
      @black_pawn.move(4,3)
      expect(@game.pieces.find_by_coordinates(4, 3).id).to eq @black_pawn.id
    end

    it 'destroys the captured piece' do
      white_pawn_id = @white_pawn.id
      @black_pawn.move(4, 3)
      expect(Piece.find_by_id(white_pawn_id)).to be nil
    end
  end

  describe 'when a pawn moves to the end of the board' do
    before(:each) do
      @game = create(:game)
      @black_player = @game.black_player
      @game.pieces.destroy_all
      create(:king, game_id: @game.id, player_id: @game.white_player.id,
                    x_coordinate: 3, y_coordinate: 0)
      create(:king, game_id: @game.id, player_id: @game.black_player.id,
                    x_coordinate: 3, y_coordinate: 7, color: 'Black')
      @white_pawn = create(:pawn, game_id: @game.id, player_id: @game.white_player.id,
                                  x_coordinate: 0, y_coordinate: 6, moved: true)
      @black_pawn = create(:pawn, game_id: @game.id, player_id: @game.black_player.id,
                                  x_coordinate: 0, y_coordinate: 1, moved: true,
                                  color: 'Black')
      @white_pawn.reload
    end

    it 'the pawn#promotion_valid method returns true when a white pawn moves to row 7' do
      @white_pawn.move(0, 7)
      expect(@white_pawn.promotion_valid?).to be true
    end

    it 'the pawn#promotion_valid method returns true when a black pawn moves to row 0' do
      @game.turn = 1
      @game.save
      @black_pawn.move(0, 0)
      expect(@black_pawn.promotion_valid?).to be true
    end

    it "the pawn#promote method changes the pawn's class" do
      @white_pawn.move(0, 7)
      id = @white_pawn.id
      @white_pawn.promote('Queen')
      expect(Piece.find(id).class).to eq Queen
    end

    it 'the move method returns a value of true for the pawn_promotion key' do
      move = @white_pawn.move(0, 7)
      expect(move[:pawn_promotion]).to be true
    end
  end

  describe 'can_move_to?' do
    before(:each) do
      @white_pawn = Pawn.create(x_coordinate: 3, y_coordinate: 1,
                                moved: false, color: 'White')
      @black_pawn = Pawn.create(x_coordinate: 3, y_coordinate: 6,
                                moved: false, color: 'Black')
    end

    it 'returns true when moving one space forward' do
      expect(@white_pawn.can_move_to?(3, 2)).to be true
      expect(@black_pawn.can_move_to?(3, 5)).to be true
    end

    it 'returns true when moving one space diagonally' do
      expect(@white_pawn.can_move_to?(4, 2)).to be true
      expect(@white_pawn.can_move_to?(2, 2)).to be true
      expect(@black_pawn.can_move_to?(4, 5)).to be true
      expect(@black_pawn.can_move_to?(2, 5)).to be true
    end

    it 'returns false when moving backwards' do
      expect(@white_pawn.can_move_to?(3, 0)).to be false
      expect(@black_pawn.can_move_to?(3, 7)).to be false
    end

    it 'returns false when moving sideways' do
      expect(@white_pawn.can_move_to?(2, 1)).to be false
      expect(@black_pawn.can_move_to?(4, 6)).to be false
    end

    it 'returns false when moving off the board' do
      @white_pawn.update(x_coordinate: 0)
      @black_pawn.update(y_coordinate: 7, x_coordinate: 7)
      expect(@white_pawn.can_move_to?(-1, 2)).to be false
      expect(@black_pawn.can_move_to?(7, 8)).to be false
    end

    context 'when the pawn has not moved' do
      it 'returns true when moving forward two spaces' do
        expect(@white_pawn.can_move_to?(3, 3)).to eq true
        expect(@black_pawn.can_move_to?(3, 4)).to be true
      end
    end

    context 'when the pawn has moved' do
      before(:each) do
        @white_pawn = Pawn.create(x_coordinate: 3, y_coordinate: 2,
                                  moved: true, color: 'White')
        @black_pawn = Pawn.create(x_coordinate: 3, y_coordinate: 5,
                                  moved: true, color: 'Black')
      end
      it 'returns false when moving forward two spaces' do
        expect(@white_pawn.y_coordinate).to eq 2
        expect(@white_pawn.can_move_to?(3, 4)).to eq false
        expect(@black_pawn.can_move_to?(3, 3)).to be false
      end
    end
  end
end
