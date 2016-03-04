# Class for Pawn Piece
class Pawn < Piece
  def valid_move?(x_new, y_new)
    return false if guard_move_is_on_board?(x_new, y_new) == false
    return false if move_attacking_own_piece?(x_new, y_new, color)
    move_x = (x_new - self.x_coordinate).abs
    # # Need to know sign of y to avoid backward move
    move_y = (y_new - self.y_coordinate)
    # White Pawn moves
    if self.color == 'White'
      return false if move_y <= 0
      if self.y_coordinate == 1
        return false unless move_y <= 2
      else
        return false unless move_y <= 1
      end
    end
    # Black Pawn moves
    if self.color == 'Black'
      return false if move_y >= 0
      if self.y_coordinate == 6 
        return false unless move_y >= -2
      else
        return false unless move_y >= -1
      end
    end
    # Diagonal moves for capturing opponents only
    if move_x > 0
      return false unless move_x == 1 && is_obstructed?(x_new, y_new)
    end
    true
  end
end
