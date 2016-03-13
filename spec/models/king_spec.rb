require 'rails_helper'
RSpec.describe King, type: :model do
  describe '#is_valid?' do
  	before(:each) do
      @game = create(:game)
      @game.pieces.destroy_all
      @king = create(:king, game_id: @game.id)
    end

    it 'makes sure move is on chess board' do
  		expect { @king.valid_move?(9,11)}.to raise_error(
        StandardError, 'The given coordinates are not on the board')
        expect(@king.valid_move?(1,2)).to eq true
    end

    it 'makes sure piece only moves one space' do
      expect(@king.valid_move?(3,3)).to eq true
      expect(@king.valid_move?(5,5)).to eq false
      expect(@king.valid_move?(3,2)).to eq true
      expect(@king.valid_move?(5,5)).to eq false
      expect(@king.valid_move?(2,3)).to eq true
      expect(@king.valid_move?(2,2)).to eq false
    end

    it 'ensures same color piece is not in way' do
      create(:pawn, x_coordinate: 3, y_coordinate: 3, game_id: @game.id)
      expect(@king.valid_move?(3,3)).to eq false
      expect(@king.valid_move?(3,2)).to eq true
    end

    it 'should return false for a move into check' do
      @king.move(4, 0)
      @rook = create(:rook, game_id: @game.id, x_coordinate: 5, y_coordinate: 2, color: 'Black')
      expect(@king.valid_move?(5, 0)).to eq false
    end
  end

  describe '#can_castle?' do
    before(:each) do
      @game = create(:game)
      @game.pieces.destroy_all
      @king = create(:king, game_id: @game.id, x_coordinate: 3, y_coordinate: 0)
      @king_side_rook = create(:rook, game_id: @game.id, x_coordinate: 0,
                                      y_coordinate: 0)
      @queen_side_rook = create(:rook, game_id: @game.id, x_coordinate: 7,
                                       y_coordinate: 0)
    end

    it 'returns true when castling is valid' do
      expect(@king.can_castle?(7, 0)).to be true
      expect(@king.can_castle?(0, 0)).to be true
    end

    context 'when an other piece is in the way' do
      it 'returns false for a queen side castle when a piece is in queen side
       knight\'s space' do
        create(:knight, game_id: @game.id, x_coordinate: 6, y_coordinate: 0)
        expect(@king.can_castle?(7, 0)).to be false
      end

      it 'returns false for a king side castle when a piece is in the king side
       bishop\'s space' do
        create(:bishop, game_id: @game.id, x_coordinate: 2, y_coordinate: 0,
                        color: 'Black')
        expect(@king.can_castle?(0, 0)).to be false
      end
    end

    context 'when one of the involved pieces has moved' do
      it 'returns false for a king side castle if the king side rook has moved' do
        @king_side_rook.move(0, 5)
        @king_side_rook.move(0, 0)
        expect(@king.can_castle?(0, 0)).to be false
      end

      it 'returns false if when queen side rook has move' do
        @queen_side_rook.move(7, 2)
        @queen_side_rook.move(7, 0)
        expect(@king.can_castle?(7, 0)).to be false
      end

      it 'returns false if the king has moved' do
        @king.move(3, 1)
        @king.move(3, 0)
        expect(@king.can_castle?(7, 0)).to be false
        expect(@king.can_castle?(0, 0)).to be false
      end
    end

    context 'there is no rook at the given space' do
      it 'returns false if the space is empty' do
        @queen_side_rook.move(7, 2)
        expect(@king.can_castle?(7, 0)).to be false
      end

      it 'returns false if a non rook piece is at the given location' do
        @queen_side_rook.move(7, 2)
        create(:knight , game_id: @game.id, x_coordinate: 7, y_coordinate: 0,
                         moved: true)
        expect(@king.can_castle?(7, 0)).to be false
      end
    end
  end

  describe '#castle!' do
    before(:each) do
      @game = create(:game)
      @game.pieces.destroy_all
      @king = create(:king, game_id: @game.id, x_coordinate: 3, y_coordinate: 0)
      @king_side_rook = create(:rook, game_id: @game.id, x_coordinate: 0,
                                      y_coordinate: 0)
      @queen_side_rook = create(:rook, game_id: @game.id, x_coordinate: 7,
                                       y_coordinate: 0)
    end
    it 'moves the the king to the correct place on a king side castle' do
      @king.castle!(0, 0)
      @king.reload
      @king_side_rook.reload
      expect(@king.x_coordinate).to eq 1
      expect(@king_side_rook.x_coordinate).to eq 2
    end

    it 'moves the the king and rook to the correct place on a queen side
     castle' do
      @king.castle!(7, 0)
      @king.reload
      @queen_side_rook.reload
      expect(@king.x_coordinate).to eq 5
      expect(@queen_side_rook.x_coordinate).to eq 4
    end
  end

  describe 'move_into_check?' do
    before(:each) do
      @game = create(:game)
      @king = @game.pieces.find_by_coordinates(3, 0)
      # This destroys the pawns in front of the Kings and Queens
      @game.pieces.where(x_coordinate: [3, 4], y_coordinate: [1, 6]).destroy_all
      # I was thinking I would just let the queen do the checking but then I
      # the queen still hasn't had it's valid_move pushed.
      # We can delete the next line and this comment when it is.
      @rook = create(:rook, game_id: @game.id, x_coordinate: 4, y_coordinate: 6, color: 'Black')
    end

    it 'should return true if a move by the King would put it in check' do
      expect(@king.move_into_check?(4, 0)).to eq true
    end

    it 'should return false if a move by the King would not put it in check' do
      @pawn = create(:pawn, game_id: @game.id, x_coordinate: 4, y_coordinate: 5, color: 'Black')
      expect(@king.move_into_check?(4, 0)).to eq false
    end
  end
end
