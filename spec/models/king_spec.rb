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
      expect(@king.valid_move?(3,1)).to eq true
      expect(@king.valid_move?(5,5)).to eq false
      expect(@king.valid_move?(2,3)).to eq true
      expect(@king.valid_move?(2,2)).to eq false
    end
  	it 'ensures same color piece is not in way' do
      create(:pawn, x_coordinate: 3, y_coordinate: 3, game_id: @game.id)
      expect(@king.valid_move?(3,3)).to eq false
      expect(@king.valid_move?(3,2)).to eq true
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
end
