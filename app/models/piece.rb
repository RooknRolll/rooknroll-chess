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
    # first check that move is on the board
    unless (0..7).cover?(x_move) && (0..7).cover?(y_move)
      raise 'The given coordinates are not on the board'
    end
    # To test that a move is vertical, horizontal, or diagonal one of three
    # things should be true: The x_coordinate is unchanged, the y_coordinate is
    # unchanged, or the absolute change for the x_coordinate equals the absolute
    # change for the y_coordinate.
    delta_x = (x_coordinate - x_move).abs
    delta_y = (y_coordinate - y_move).abs
    unless delta_x == 0 || delta_y == 0 || delta_x == delta_y
      raise 'This move is not a valid move for this method to check'
    end
    intervening_spaces = []
    if delta_x > 1
      range_x = x_coordinate < x_move ? (x_coordinate + 1 .. x_move - 1) :
                                        (x_move + 1 .. x_coordinate - 1)
    end
    if delta_y > 1
      range_y = y_coordinate < y_move ? (y_coordinate + 1 .. y_move - 1):
                                        (y_move + 1 .. y_coordinate - 1)
    end
    if range_x && range_y
      range_x.each_with_index do |x, index|
        intervening_spaces << [x, range_y.to_a[index]]
      end
    elsif range_x
      range_x.each { |x| intervening_spaces << [x, y_coordinate] }
    elsif range_y
      range_y.each { |y| intervening_spaces << [x_coordinate, y] }
    end
    intervening_spaces.each do |space_coordinates|
      x = space_coordinates[0]
      y = space_coordinates[1]
      if game.pieces.where('x_coordinate = ? and y_coordinate = ?', x, y).first
        return true
      end
    end
    false
  end
end
