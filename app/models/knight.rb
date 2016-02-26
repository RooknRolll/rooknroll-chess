# Class for Knight Piece
class Knight < Piece
  def valid_move?(x_coordinate, y_coordinate)
    self.guard_move_is_on_board?(x_coordinate, y_coordinate)
  end
end
