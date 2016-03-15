# Class for Bishop Piece
class Bishop < Piece
  def valid_move?(x_new, y_new)
    return false unless move_is_diagonal?(x_new, y_new)
    # puts "move_is_diagonal passed"
    return false if is_obstructed?(x_new, y_new)
    # puts "is_obstructed passed"
    return false if move_attacking_own_piece?(x_new, y_new, color)
    true
  end
end
