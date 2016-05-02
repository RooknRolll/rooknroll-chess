class Piece < ActiveRecord::Base
  belongs_to :player
  belongs_to :game
  has_many :en_passants, dependent: :destroy
  scope :bishops, -> { where(type: 'Bishop') }
  scope :kings, -> { where(type: 'King') }
  scope :knights, -> { where(type: 'Knight') }
  scope :pawns, -> { where(type: 'Pawn') }
  scope :queens, -> { where(type: 'Queen') }
  scope :rooks, -> { where(type: 'Rook') }
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
    glyph_type = type.downcase
    "glyphicon glyphicon-#{glyph_type} glyph-#{glyph_color} piece"
  end

  def can_move_to?(x_move, y_move)
    possible_moves.include?([x_move, y_move])
  end

  def move(x_new, y_new)
    move_data = initialize_move_data
    return move_data unless correct_turn?
    return castle!(x_new, y_new) if castling_move?(x_new, y_new)
    if valid_move?(x_new, y_new) && !move_into_check?(x_new, y_new)
      id_of_captured_piece = find_and_capture(x_new, y_new)
      update_attributes(x_coordinate: x_new, y_coordinate: y_new, moved: true)
      # destroy all enpassants on the other side to prevent them from being
      # valid moves in subsequent turns
      game.next_turn!
      move_data = successful_move_data(id_of_captured_piece, [hash_of_id_and_coordinates])
    end
    move_data
  end

  def game_check_and_turn_status
    game.check_and_turn_status
  end

  def successful_move_data(captured_piece_id, moving_pieces)
    {
      success: true,
      captured_piece: captured_piece_id,
      moved_pieces: moving_pieces,
      check_status: { check: game.check_status },
      pawn_promotion: promotion_valid?,
      turn: game.color_turn
    }
  end

  def move_into_check?(x_new, y_new)
    # Find any piece that is being attacked, and place it off board.
    attacked_piece = game.pieces.find_by_coordinates(x_new, y_new)
    # Determine if move is EnPassant and remove attacked piece from board
    attacked_piece ||= deterimine_en_passant(x_new, y_new)
    attacked_piece && attacked_piece.place_off_board

    # Remember where the piece came from, so we can put it back.
    old_attributes = { x_coordinate: x_coordinate, y_coordinate: y_coordinate, moved: moved }
    # Update attributes
    update_attributes(x_coordinate: x_new, y_coordinate: y_new, moved: true)
    # Determine if this has moved the player into check, save it to variable
    check = game.check?(color)
    # Put everything back
    update_attributes(old_attributes)
    if attacked_piece
      attacked_piece.update_attributes(x_coordinate: x_new, y_coordinate: y_new)
    end
    check
  end

  def place_off_board
    # At first I tried setting coordinates to nil, but that gave me problems
    # From these coordinates the piece is incappable of having a valid move that
    # lands on the board.
    update_attributes(x_coordinate: 8, y_coordinate: 16)
  end

  def deterimine_en_passant(x, y)
    ep = game.en_passants.find_by_coordinates(x, y)
    return nil unless type == 'Pawn' && ep
    ep.piece
  end

  def find_and_capture(x, y)
    captured_piece = game.pieces.find_by_coordinates(x, y)
    # save the captured pieces id
    id_of_captured_piece = captured_piece ? captured_piece.id : nil
    # This next line checks that a captured piece exists and destroys it.
    captured_piece && captured_piece.destroy
    id_of_captured_piece
  end

  def opposite_color
    if color == 'White'
      'Black'
    elsif color == 'Black'
      'White'
    else
      raise 'not a valid color'
    end
  end

  def valid_move?(_x_new, _y_new)
    false
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

  def piece_turn?
    color == game.color_turn
  end

  def correct_player?
    player == game.player_turn
  end

  def correct_turn?
    piece_turn? && correct_player?
  end

  def has_valid_moves?
    game.all_board_spaces.each do |arr|
      x = arr[0]
      y = arr[1]
      if valid_move?(x, y) &&
         !move_into_check?(x, y)
        return true
      end
    end
    false
  end

  def hash_of_id_and_coordinates
    {
      id: id,
      x_coordinate: x_coordinate,
      y_coordinate: y_coordinate
    }
  end

  private

  def possible_moves
    []
  end

  def castling_move?(_x_move, _y_move)
    false
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
    return false unless delta_x == 0 || delta_y == 0
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

  def initialize_move_data
    data = {
      success: false,
      moved_pieces: [hash_of_id_and_coordinates],
      captured_piece: nil,
      check_status: game.check_status,
      pawn_promotion: false,
      turn: game.color_turn
    }
    data
  end

  def promote
    { success: false, check_status: false }
  end

  def promotion_valid?
    false
  end

  def move_grid
    arr = (0..7).to_a
    arr.product(arr)
  end

  def spaces_diagonal_from_piece
    move_grid.select do |arr|
      delta_x = (x_coordinate - arr[0]).abs
      delta_y = (y_coordinate - arr[1]).abs
      delta_x == delta_y && !(delta_x == 0 && delta_y == 0)
    end
  end

  def spaces_horizontal_or_vertical_from_piece
    move_grid.select do |arr|
      delta_x = (x_coordinate - arr[0]).abs
      delta_y = (y_coordinate - arr[1]).abs
      (delta_x != delta_y) && (delta_x == 0 || delta_y == 0)
    end
  end

  def spaces_one_space_away_from_piece
    move_grid.select do |arr|
      delta_x = (x_coordinate - arr[0]).abs
      delta_y = (y_coordinate - arr[1]).abs
      delta_x <= 1 && delta_y <= 1 && !(delta_x == 0 && delta_y == 0)
    end
  end
end
