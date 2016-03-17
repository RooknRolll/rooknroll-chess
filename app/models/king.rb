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
    # Check that none of the spaces that the king moves through are attacked
    spaces_moved_through_by_castle(rook_x).each do |x_space|
      return false if move_into_check?(x_space, y_coordinate)
    end
    true
  end

  def spaces_moved_through_by_castle(rook_x)
    rook_x == 7 ? [4, 5] : [1, 2]
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
end
