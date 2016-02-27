# Class for Knight Piece
class Knight < Piece
  def valid_move?(x, y)
    false if self.guard_move_is_on_board?(x, y) == false
    move_x = (x - self.x_coordinate).abs
    move_y = (y - self.y_coordinate).abs
    unless move_x == 2 && move_y == 1 || move_x == 1 && move_y == 2
      false
    else
      true
    end
  end
end
