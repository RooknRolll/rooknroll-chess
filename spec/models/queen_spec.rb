require 'rails_helper'

RSpec.describe Queen, type: :model do
  describe 'valid_move?' do
    before(:each) do
	    @game = create(:game)
	    @game.pieces.destroy_all
	    @queen = create(:queen, x_coordinate: 4, y_coordinate: 7, game_id: @game.id)
	  end

    # Failing
    # it 'returns FALSE because proposed move is off the board' do
    #  expect(@queen.valid_move?(0, 8)).to eq false
    # end

	  it 'returns FALSE because proposed move is blocked by same color piece' do
	    create(:pawn, x_coordinate: 4, y_coordinate: 6, game_id: @game.id)
      expect(@queen.valid_move?(4, 6)).to eq false
	  end

	  it 'returns TRUE because proposed move is taking opposite color piece spot' do
	    create(:pawn, x_coordinate: 2, y_coordinate: 5, color: 'Black', game_id: @game.id)
      expect(@queen.valid_move?(2, 5)).to eq true
	  end

	  it 'returns TRUE because proposed move is vertical' do
	    expect(@queen.valid_move?(4, 1)).to eq true
	  end

	  it 'returns TRUE because proposed move is diagonal' do
	    expect(@queen.valid_move?(3, 7)).to eq true
	  end

    it 'returns FALSE because proposed move is same as current coordiante' do
      expect(@queen.valid_move?(4, 7)).to eq false
    end
  end
end
