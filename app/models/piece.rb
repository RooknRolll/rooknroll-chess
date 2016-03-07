class Piece < ActiveRecord::Base
  belongs_to :player
  belongs_to :game
  scope :bishops, -> { where(type: ‘Bishop’) }
  scope :kings, -> { where(type: ‘King’) }
  scope :knights, -> { where(type: ‘Knight’) }
  scope :pawns, -> { where(type: ‘Pawn’) }
  scope :queens, -> { where(type: ‘Queen’) }
  scope :rooks, -> { where(type: ‘Rook’) }
  # Adding scope allow calling methods like, Piece.kings, Piece.pawns, Piece.rooks
  # Piece.all, King.all, Pawn.all, Rook.all
  # Note sure if this is necessary but will leave it here for now.

  def self.types
    # this is an arry of strings with the name of each piece.
    %w(Pawn Rook Knight Bishop Queen King)
  end

  def glyph
    # Returns classes html classes that create a glyph of the piece with
    # the correct color.
    glyph_color = color.downcase
    glyph_type =
      case type
      when 'Rook'
        'tower'
      else
        type.downcase
      end
    return "glyphicon glyphicon-#{glyph_type} glyph-#{glyph_color} piece"
  end

  def move(x_new, y_new)
    return castle!(x_new, y_new) if castling_move?(x_new, y_new)
    if valid_move?(x_new, y_new)
      captured_piece = game.pieces.find_by_coordinates(x_new, y_new)
      # This next line checks that a captured piece exists and destroys it.
      captured_piece && captured_piece.destroy
      update_attributes(x_coordinate: x_new, y_coordinate: y_new, moved: true)
      return true if save
    end
    false
  end

  def valid_move?(x_new, y_new)
    # # I pulled out the portions of the valid move method that all piece types
    # # should be calling, and placed them here. Check the bishop model to see
    # # how to call it.
    # return false unless actual_move?(x_new, y_new)
    # puts "actual_move passed"
    # return false if move_attacking_own_piece?(x_new, y_new, color)
    # puts "move_attacking_own_piece passed"
    # true
  end

  def self.find_by_coordinates(column, row)
    # Finds a piece by the given coordinates.
    # When you call this method you should narrow the results to a specific game.
    where(y_coordinate: row, x_coordinate: column).first
  end

  def is_obstructed?(x_move, y_move)
    guard_move_is_on_board?(x_move, y_move)
    guard_move_is_linear(x_move, y_move)
    # Set a range of the x values between the current position and the move
    # position
    range_x = set_range(x_coordinate, x_move) || []
    # Set a range of the y values between the current position and the move
    # position
    range_y = set_range(y_coordinate, y_move) || []
    # Call spaces_between to get a list of the coordinates of the spaces between
    # current position and the move's position.
    check_for_pieces(spaces_between(range_x, range_y))
  end

  def move_is_diagonal?(x_move, y_move)
    delta_x = (x_coordinate - x_move).abs
    delta_y = (y_coordinate - y_move).abs
    delta_x == delta_y
  end

  def move_attacking_own_piece?(x_move, y_move, color)
    attacked_piece = game.pieces.where(x_coordinate: x_move,
                                       y_coordinate: y_move).first
    return false if attacked_piece.nil?
    attacked_piece.color == color
  end

  def actual_move?(x_move, y_move)
    x_move != x_coordinate && y_move != y_coordinate
  end

  private

  def castling_move?(x_move, y_move)
    # First, moving piece must be a king.
    return false unless type == 'King'
    # Second, king must be able to castle with given coordinates
    return false unless can_castle?(x_move, y_move)
    true
  end

  def check_for_pieces(coordinate_array)
    # Given an array of coordinates in the form of arrays containing two numbers
    # Return true if a piece exists in this game on those coordinates
    coordinate_array.each do |space_coordinates|
      x = space_coordinates[0]
      y = space_coordinates[1]
      # For each space between the current location and the move location we
      # check if a piece exists in that space. If a piece is found return true.
      if game.pieces.find_by_coordinates(x, y)
        return true
      end
    end
    false
  end

  def guard_move_is_on_board?(x_move, y_move)
    unless (0..7).cover?(x_move) && (0..7).cover?(y_move)
      raise 'The given coordinates are not on the board'
    end
  end

  def guard_move_is_linear(x_move, y_move)
    # Move is linear if the x_coordinate does not change, the y_coordinate does
    # not change, or if the change to the x_coordinate equals the change to
    # the y_coordinate
    delta_x = (x_coordinate - x_move).abs
    delta_y = (y_coordinate - y_move).abs
    unless delta_x == 0 || delta_y == 0 || delta_x == delta_y
      raise 'This move is not a valid move for this method to check'
    end
    true
  end

  def move_is_NSEW(x_move, y_move)
    # Move is NSEW if the x_coordinate does not change, or the y_coordinate does not change
    delta_x = (x_coordinate - x_move).abs
    delta_y = (y_coordinate - y_move).abs
    unless delta_x == 0 || delta_y == 0
      raise 'This move is not allowed'
    end
    true
  end

  def set_range(origin, end_place)
    # This method returns a range of values between the values given it.
    # Example : set_range(7, 2) => (3..6)
    # I had to change this to also give reverse ranges
    if origin < end_place
      return (origin + 1 ... end_place).to_a
    elsif origin > end_place
      range = ((origin - 1) ... end_place + 1)
      return range.first.downto(range.last).map{ |n| n }
    else
      []
    end
  end

  def spaces_between(array_x, array_y)
    intervening_spaces = []
    # Add to intervening_spaces a list of the coordinates of all the spaces
    # between the current location and the move location.
    if array_x.any? && array_y.any?
      # These next 3 lines run if the move is diagonal
      array_x.each_with_index do |num, index|
        intervening_spaces << [num, array_y[index]]
      end
      # This runs if the move is horizontal
    elsif array_x.any?
      array_x.each { |num| intervening_spaces << [num, y_coordinate] }
      # This runs if the move is vertical
    elsif array_y.any?
      array_y.each { |num| intervening_spaces << [x_coordinate, num] }
    end
    intervening_spaces
  end
end
