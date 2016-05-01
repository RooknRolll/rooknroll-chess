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

  private

  def possible_moves
    move_grid.select do |arr|
      delta_x = (x_coordinate - arr[0]).abs
      delta_y = (y_coordinate - arr[1]).abs
      delta_x == delta_y
    end
  end
end
