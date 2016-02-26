require 'rails_helper'

RSpec.describe Knight, type: :model do
  before(:each) do
    @game = create(:game)
    @game.pieces.destroy_all
    @queen = create(:queen, game_id: @game.id)
    @knight = create(:knight, game_id: @game.id)
  end
  it 'raises an error when the move destination is off the board' do
    expect { @knight.valid_move?(8, 2) }.to raise_error(
      StandardError, 'The given coordinates are not on the board')
  end
end