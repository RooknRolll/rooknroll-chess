require 'rails_helper'

RSpec.describe Move, type: :class do
  describe 'initialize' do
    it 'takes an x_coordinate, y_coordinate, and a piece' do
      king = double
      # king = create(:king)
      move = Move.new(king, 3, 3)
      expect(move.piece).to eq king
    end
  end
  describe "Move.valid?" do
    before(:each) do
      @king = double('King')
      # @king = create(:king)
      @move = Move.new(@king, 3, 3)
    end
    it 'calls a pieces valid_move method' do
      allow(@king).to receive(:valid_move?)
      expect(@king).to receive(:valid_move?).with(3, 3)
      @move.valid?
    end
  end
end
