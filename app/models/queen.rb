# Class Queen Piece
class Queen < Piece
  def valid_move?(x_new, y_new)
    return false unless move_is_diagonal?(x_new, y_new) || move_is_NSEW(x_new, y_new)
    return false if is_obstructed?(x_new, y_new)
    return false if move_attacking_own_piece?(x_new, y_new, color)
    true
  end

  def possible_moves
    spaces_horizontal_or_vertical_from_piece |
      spaces_diagonal_from_piece
  end
end
