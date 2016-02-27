# Class for Knight Piece
class Knight < Piece
  def valid_move?(x_new, y_new)
    return false if guard_move_is_on_board?(x_new, y_new) == false
    return false if move_attacking_own_piece?(x_new, y_new, color)
    move_x_new = (x - self.x_coordinate).abs
    move_y_new = (y - self.y_coordinate).abs
    unless move_x == 2 && move_y == 1 || move_x == 1 && move_y == 2
      false
    else
      true
    end
  end
end
