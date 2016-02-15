class Game < ActiveRecord::Base
  belongs_to :black_player, class_name: 'Player'
  belongs_to :white_player, class_name: 'Player'
  has_many :pieces

  delegate :kings, :pawns, :rooks, :queens, :knights, :bishops to: :pieces
  # Using deligate allows methods like, game.pawns, game.kings, game.rooks, game.pieces

end
