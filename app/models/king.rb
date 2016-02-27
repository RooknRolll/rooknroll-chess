# Class for King Piece
require "byebug"
class King < Piece
  def valid_move?(new_x, new_y)
  	guard_move_is_on_board?(new_x, new_y)
  	return false unless one_space?(x_coordinate, y_coordinate)
  	piece = Piece.find_by_coordinates(new_x, new_y)
  	return false unless piece == nil || piece.color != self.color
  	return true
  end

  def one_space?(x_coordinate, y_coordinate)
  	return (x_coordinate + 1 || x_coordinate - 1 || x_coordinate == new_x) &&
  	       (y_coordinate + 1 || y_coordinate - 1 || y_coordinate == new_y) 	
  end
end