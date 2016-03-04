# Class for Pawn Piece
class Pawn < Piece
  def valid_move?(x_new, y_new)
    return false if guard_move_is_on_board?(x_new, y_new) == false
    return false if move_attacking_own_piece?(x_new, y_new, color)
    move_x = (x_new - self.x_coordinate).abs
    # # Need to know sign of y to avoid backward move
    move_y = (y_new - self.y_coordinate)
    return false if self.color == 'White' && (move_y <= 0)
    return false if self.color == 'Black' && (move_y >= 0)
    # Allow a first move of 2 spaces
    unless self.color == 'White' && self.y_coordinate == 1
      return false if move_y == 2
    end
    unless self.color == 'Black' && self.y_coordinate == 6 
      return false if move_y == -2
    end
    # Diagonal moves for capturing moves only
    # if move_x > 0
    #   return false unless move_x == 1 && move_to!
    # end
    true
  end
end
