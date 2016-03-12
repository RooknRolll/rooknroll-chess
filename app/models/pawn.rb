# Class for Pawn Piece
class Pawn < Piece
  def valid_move?(x_new, y_new)
    return false if move_attacking_own_piece?(x_new, y_new, color)
    return false unless forward_move?(y_new)
    move_y = move_y(y_new)
    move_x = move_x(x_new)
    occupied ||= space_occupied?(x_new, y_new)

    ((one_space_forward?(move_x, move_y.abs) && !occupied) ||
      (two_spaces_forward?(move_x, move_y.abs) && !occupied) ||
      (diagonal?(move_x, move_y.abs) && attack?(x_new, y_new))) &&
      !is_obstructed?(x_new, y_new)
  end

  def move(x_new, y_new)
    return false unless valid_move?(x_new, y_new)
    move_y = move_y(y_new).abs
    move_x = move_x(x_new)
    create_en_passant if two_spaces_forward?(move_x, move_y)
    attack_any_en_passant(x_new, y_new)
    find_and_capture(x_new, y_new)
    update_attributes(x_coordinate: x_new, y_coordinate: y_new, moved: true)
    destroy_en_passants
  end

  def forward_move?(y_new)
    move_y = move_y(y_new)
    return false if color == 'White' && move_y <= 0
    return false if color == 'Black' && move_y >= 0
    true
  end

  def one_space_forward?(move_x, move_y)
    move_x == 0 && move_y == 1
  end

  def two_spaces_forward?(move_x, move_y)
    move_x == 0 && move_y == 2 && first_move?
  end

  def move_y(y_new)
    # Sign of y needed. Pawns go forward only.
    y_new - y_coordinate
  end

  def move_x(x_new)
    (x_new - x_coordinate).abs
  end

  def first_move?
    !moved
  end

  def space_occupied?(x_new, y_new)
    game.pieces.find_by_coordinates(x_new, y_new)
  end

  def diagonal?(move_x, move_y)
    move_x == 1 && move_y == 1
  end

  def attack?(x_new, y_new)
    object = game.pieces.find_by_coordinates(x_new, y_new) ||
             game.en_passants.find_by_coordinates(x_new, y_new)
    return false unless object
    opposite_color == object.color
  end

  def create_en_passant
    y = color == 'White' ? 2 : 5
    en_passants.create(x_coordinate: x_coordinate,
                       y_coordinate: y,
                       color: color,
                       game_id: game.id)
  end

  def attack_any_en_passant(x, y)
    en_passant = game.en_passants.find_by_coordinates(x, y)
    en_passant && en_passant.capture
  end
end
