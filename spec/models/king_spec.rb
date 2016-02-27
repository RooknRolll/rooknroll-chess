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
  	

  end
end
