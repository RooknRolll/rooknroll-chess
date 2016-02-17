# Class for Games
class Game < ActiveRecord::Base
  belongs_to :black_player, class_name: 'Player'
  belongs_to :white_player, class_name: 'Player'
  has_many :pieces

  delegate :kings, :pawns, :rooks, :queens, :knights, :bishops, to: :pieces
  # Using deligate allows methods like, game.pawns
  # game.kings, game.rooks, game.pieces

  def self.with_open_seats
    Game.where('white_player_id IS :nil or black_player_id IS :nil', nil: nil)
  end
end
