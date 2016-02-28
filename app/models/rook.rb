# Class for Rook Piece
class Rook < Piece
  def valid_move?(new_x, new_y)
  	return false unless move_is_NSEW(new_x, new_y)
  	return false if is_obstructed?(new_x, new_y)
  	return false if move_attacking_own_piece?(new_x, new_y, color)
  	true
  end

  def castle
  end
end