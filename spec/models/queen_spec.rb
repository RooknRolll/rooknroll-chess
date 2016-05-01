require 'rails_helper'

RSpec.describe Queen, type: :model do
  describe 'valid_move?' do
    before(:each) do
	    @game = create(:game)
	    @game.pieces.destroy_all
	    @queen = create(:queen, x_coordinate: 4, y_coordinate: 7, game_id: @game.id)
	  end

    # Failing
    it 'returns FALSE because proposed move is off the board' do
      expect(@queen.valid_move?(0, 8)).to eq false
    end

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

  describe 'can_move_to?' do
    before(:all) do
      @queen = Queen.create(x_coordinate: 3, y_coordinate: 3)
    end

    it 'returns true for horizontal moves' do
      expect(@queen.can_move_to?(0, 3)).to be true
      expect(@queen.can_move_to?(7, 3)).to be true
      expect(@queen.can_move_to?(2, 3)).to be true
      expect(@queen.can_move_to?(4, 3)).to be true
    end

    it 'returns true for vertical moves' do
      expect(@queen.can_move_to?(3, 2)).to be true
      expect(@queen.can_move_to?(3, 4)).to be true
      expect(@queen.can_move_to?(3, 0)).to be true
      expect(@queen.can_move_to?(3, 7)).to be true
    end

    it 'returns true for diagonal moves' do
      expect(@queen.can_move_to?(6, 6)).to eq true
      expect(@queen.can_move_to?(1, 1)).to eq true
      expect(@queen.can_move_to?(1, 5)).to eq true
      expect(@queen.can_move_to?(5, 1)).to eq true
    end

    it 'returns false for non horizontal, vertical or diagonal moves' do
      expect(@queen.can_move_to?(4, 5)).to eq false
      expect(@queen.can_move_to?(6, 5)).to eq false
      expect(@queen.can_move_to?(0, 2)).to eq false
    end

    it 'returns false for moves off the board' do
      expect(@queen.can_move_to?(3, 8)).to eq false
      expect(@queen.can_move_to?(-1, 3)).to eq false
      expect(@queen.can_move_to?(8, 8)).to eq false
      expect(@queen.can_move_to?(-1, -1)).to eq false
    end

    it 'returns false for non-moves' do
      expect(@queen.can_move_to?(3, 3)).to eq false
    end
  end
end
