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
    true
  end
end
