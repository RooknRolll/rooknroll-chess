# Class for Pawn Piece
class Pawn < Piece
  def valid_move?(x_new, y_new)
    move_y = move_y(y_new)
    move_x = move_x(x_new)
    return false if guard_move_is_on_board?(x_new, y_new)
    return false if move_attacking_own_piece?(x_new, y_new, color)
    return false if backwards_move?(y_new)
    return false unless (first_move? && move_y.abs <= 2) || move_y.abs <= 1
    return false if move_x != 0 && !diagonal_attack_move?(x_new, y_new)
    true
  end

  def backwards_move?(y_new)
    move_y = move_y(y_new)
    return true if color == 'White' && move_y <= 0
    return true if color == 'Black' && move_y >= 0
    false
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

  def diagonal_attack_move?(x_new, y_new)
    move_x = move_x(x_new)
    false unless move_x == 1 && is_obstructed?(x_new, y_new)
  end
end
