# Moves a piece.
class Move
  attr_reader :x_coordinate, :y_coordinate, :piece, :data

  def initialize(piece, x_coordinate, y_coordinate)
    @x_coordinate = x_coordinate
    @y_coordinate = y_coordinate
    @piece = piece
    @data = initialize_move_data
  end

  def valid?
    piece.can_move_to?(x_coordinate, y_coordinate)
  end

  protected

  def initialize_move_data
    {
      success: false,
      moved_pieces: [piece.hash_of_id_and_coordinates],
      captured_piece: nil,
      pawn_promotion: false
    }.merge(piece.game_check_and_turn_status)
  end
end
