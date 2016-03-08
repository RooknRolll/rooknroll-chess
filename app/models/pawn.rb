# Class for Pawn Piece
class Pawn < Piece
  def valid_move?(x_new, y_new)
    return false if guard_move_is_on_board?(x_new, y_new) == false
    return false if is_obstructed?(x_new, y_new)
    return false if move_attacking_own_piece?(x_new, y_new, color)
    return false unless forward_move?(y_new)
    move_y = move_y(y_new)
    move_x = move_x(x_new)
    return false unless (first_move? && move_y.abs <= 2) || move_y.abs <= 1
    if space_occupied?(x_new, y_new) || move_x != 0
      return false unless attack?(x_new, y_new)
    end
    true
  end

  def forward_move?(y_new)
    move_y = move_y(y_new)
    return false if color == 'White' && move_y <= 0
    return false if color == 'Black' && move_y >= 0
    true
  end

  def move_y(y_new)
    # Sign of y needed. Pawns go forward only.
    y_new - y_coordinate
  end

  def move_x(x_new)
    (x_new - x_coordinate).abs
  end

  def first_move?
    return true if color == 'White' && y_coordinate == 1
    return true if color == 'Black' && y_coordinate == 6
    false
  end

  def space_occupied?(x_new, y_new)
    game.pieces.find_by_coordinates(x_new, y_new)
  end

  def attack?(x_new, y_new)
    move_x = move_x(x_new)
    move_y = move_y(y_new).abs
    return false unless move_x == 1 && move_y == 1
    return false unless space_occupied?(x_new, y_new)
    return false if move_attacking_own_piece?(x_new, y_new, color)
    true
  end
end
