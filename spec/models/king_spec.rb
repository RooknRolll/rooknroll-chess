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
end