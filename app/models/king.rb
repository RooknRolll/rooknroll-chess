# Class for King Piece
class King < Piece
	

	def valid_move?
	  move_logic_is_valid = false
			if legit_moves.include? [new_x, new_y]
				return true
			else
				return false
			end
		end

		def legit_moves
			piece = Piece.find(self.id)
			x_init = piece.x_coord
			y_init = piece.y_coord
			
			# list of moves available to King: 
			up = [x_init, y_init + 1]
			down = [x_init, y_init - 1]
			right = [x_init + 1, y_init]
			left = [x_init - 1, y_init]
			up_right = [x_init + 1, y_init + 1]
			up_left = [x_init - 1, y_init + 1]
			down_right = [x_init + 1, y_init - 1]
			down_left = [x_init - 1, y_init - 1]

			valid_moves = []

			# King can move only if: 
			can_move_up = y_init != 7 
			can_move_down = y_init != 0 
			can_move_left = x_init != 0 
			can_move_right = x_init != 7 

			valid_moves.push(up) if can_move_up
			valid_moves.push(down) if can_move_down
			valid_moves.push(left) if can_move_left
			valid_moves.push(right) if can_move_right
			valid_moves.push(up_right) if can_move_up && can_move_right 
			valid_moves.push(up_left) if can_move_up && can_move_left
			valid_moves.push(down_right) if can_move_down && can_move_right
			valid_moves.push(down_left) if can_move_down && can_move_left

			return valid_moves 

		end
