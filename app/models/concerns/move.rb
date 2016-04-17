# Moves a piece.
class Move
  attr_reader :x_coordinate, :y_coordinate, :piece

  def initialize(piece, x_coordinate, y_coordinate)
    @x_coordinate = x_coordinate
    @y_coordinate = y_coordinate
    @piece = piece
  end

  def valid?
    piece.valid_move?(x_coordinate, y_coordinate)
  end
end
