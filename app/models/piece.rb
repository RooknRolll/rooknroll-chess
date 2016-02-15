class Piece < ActiveRecord::Base
  belongs_to :player
  belongs_to :game
  scope :bishops, -> { where(type: ‘Bishop’) }
  scope :kings, -> { where(type: ‘King’) }
  scope :knights, -> { where(type: ‘Knight’) }
  scope :pawns, -> { where(type: ‘Pawn’) }
  scope :queens, -> { where(type: ‘Queen’) }
  scope :rooks, -> { where(type: ‘Rook’) }
  # Adding scope allow calling methods like, Piece.kings, Piece.pawns, Piece.rooks
  # Piece.all, King.all, Pawn.all, Rook.all
  # Note sure if this is necessary but will leave it here for now.

  def self.types
    #this is an arry of strings with the name of each piece.
    %w(Pawn Rook Knight Bishop Queen King)
  end

  def valid_move? x_coordinate, y_coordinate

  end

end
