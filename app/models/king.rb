class King < Piece
  def valid_move?(new_x, new_y)
    guard_move_is_on_board?(new_x, new_y)
    return false unless one_space?(new_x, new_y)
    piece = game.pieces.find_by_coordinates(new_x, new_y)
    return false unless piece.nil? || piece.color != color
    true
  end

  def one_space?(new_x, new_y)
    (new_x - x_coordinate).abs <= 1 && (new_y - y_coordinate).abs <= 1
  end

  def can_castle?(rook_x, rook_y)
    # return false if king has moved
    return false if moved
    rook = game.pieces.find_by_coordinates(rook_x, rook_y)
    # return false if there is no piece at the given location,
    # or if that piece is not a rook
    return false unless rook && rook.type == 'Rook'
    # return false if rook has moved
    return false if rook.moved
    # return false if a piece is in the way
    return false if is_obstructed?(rook_x, rook_y)
    # One of the rules for castling requires that the king not be in check, and
    # all the squares that the king will move through during the castle are not
    # in check. Will need to add code for that when check testing has been
    # implemented.
    true
  end

  def castle!(rook_x, rook_y)
    return false unless can_castle?(rook_x, rook_y)
    # find the rook
    rook = game.pieces.find_by_coordinates(rook_x, rook_y)
    # Decide where the king is moving
    king_x = rook_x == 7 ? 5 : 1
    rook_move = rook_x == 7 ? 4 : 2
    # Move the king, I chose to update_attributes directly rather than use the
    # move method because the valid_move would reject this move.
    update_attributes(x_coordinate: king_x, moved: true)
    # Move the rook.
    rook.update_attributes(x_coordinate: rook_move, moved: true)
    return true if rook.save && save
  end

  def move_into_check?(x_new, y_new)

  end
end
