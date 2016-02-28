class King < Piece

  def valid_move?(new_x, new_y)
  	guard_move_is_on_board?(new_x, new_y)
  	return false unless one_space?(new_x, new_y)
  	piece = game.pieces.find_by_coordinates(new_x, new_y)
  	return false unless piece == nil || piece.color != self.color
  	return true
  end

  def one_space?(new_x, new_y)
  	return (new_x - x_coordinate).abs <= 1 && (new_y - y_coordinate).abs <= 1
  end
end
