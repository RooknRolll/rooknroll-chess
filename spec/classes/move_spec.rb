require 'rails_helper'

RSpec.describe Move, type: :class do
  before(:each) do
    @king = double
    status_hash = { check: false, turn: 'Black' }
    allow(@king).to receive(:hash_of_id_and_coordinates) do
      {
        id: 5,
        x_coordinate: 2,
        y_coordinate: 1 }
    end
    allow(@king).to receive(:game_check_and_turn_status) { status_hash }
  end

  describe 'initialize' do
    before(:each) do
      @move = Move.new(@king, 3, 0)
    end

    it 'initializes a piece' do
      expect(@move.piece).to eq @king
    end

    it 'takes a x_coordinate' do
      expect(@move.x_coordinate).to eq 3
    end

    it 'takes a y_coordinate' do
      expect(@move.y_coordinate).to eq 0
    end

    it 'initializes move data hash' do
      expected_hash = {
        success: false,
        moved_pieces: [{ id: 5, x_coordinate: 2, y_coordinate: 1 }],
        captured_piece: nil,
        pawn_promotion: false,
        check: false,
        turn: 'Black'
      }
      expect(@move.data).to eq expected_hash
    end
  end
end
