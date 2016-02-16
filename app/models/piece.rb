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
    #this is an arry of strings with the name of each piece.
    %w(Pawn Rook Knight Bishop Queen King)
  end

  def valid_move?(x_coordinate, y_coordinate)

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

  private

  def check_for_pieces(coordinate_array)
    # Given an array of coordinates in the form of arrays containing two numbers
    # Return true if a piece exists in this game on those coordinates
    coordinate_array.each do |space_coordinates|
      x = space_coordinates[0]
      y = space_coordinates[1]
      # For each space between the current location and the move location we
      # check if a piece exists in that space. If a piece is found return true.
      if game.pieces.where('x_coordinate = ? and y_coordinate = ?', x, y).first
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

  def set_range(origin, end_place)
    # This method returns a range of values between the values given it.
    # Example : set_range(7, 2) => (3..6)
    if origin < end_place
      ((origin + 1)..(end_place - 1))
    else
      ((end_place + 1)..(origin - 1))
    end
  end

  def spaces_between(range_x, range_y)
    intervening_spaces = []
    # Add to intervening_spaces a list of the coordinates of all the spaces
    # between the current location and the move location.
    if range_x.any? && range_y.any?
      # These next 3 lines run if the move is diagonal
      range_x.each_with_index do |x, index|
        intervening_spaces << [x, range_y.to_a[index]]
      end
    elsif range_x.any?
      # This runs if the move is horizontal
      range_x.each { |x| intervening_spaces << [x, y_coordinate] }
    elsif range_y.any?
      # This runs if the move is vertical
      range_y.each { |y| intervening_spaces << [x_coordinate, y] }
    end
    intervening_spaces
  end
end
