# Class for Games
class Game < ActiveRecord::Base
  belongs_to :black_player, class_name: 'Player'
  belongs_to :white_player, class_name: 'Player'
  has_many :pieces
  has_many :en_passants

  after_create :populate_board!

  delegate :kings, :pawns, :rooks, :queens, :knights, :bishops, to: :pieces
  # Using delegate allows methods like, game.pawns
  # game.kings, game.rooks, game.pieces
  # Cassie: I think we can use this for the populate_board! below, but not sure.

  def self.with_open_seats
    Game.where('white_player_id IS :nil or black_player_id IS :nil', nil: nil)
  end

  # Populate the board
  def populate_board!
    # // Black Pieces

    # Back Row from left to right
    pieces.create(:type => 'Rook', :color => "Black", :x_coordinate => 0, :y_coordinate => 7)
    pieces.create(:type => 'Knight', :color => "Black", :x_coordinate => 1, :y_coordinate => 7)
    pieces.create(:type => 'Bishop', :color => "Black", :x_coordinate => 2, :y_coordinate => 7)
    pieces.create(:type => 'King', :color => "Black", :x_coordinate => 3, :y_coordinate => 7)
    pieces.create(:type => 'Queen', :color => "Black", :x_coordinate => 4, :y_coordinate => 7)
    pieces.create(:type => 'Bishop', :color => "Black", :x_coordinate => 5, :y_coordinate => 7)
    pieces.create(:type => 'Knight', :color => "Black", :x_coordinate => 6, :y_coordinate => 7)
    pieces.create(:type => 'Rook', :color => "Black", :x_coordinate => 7, :y_coordinate => 7)

    # Pawns Row from left to right
    (0..7).each do |p|
    	pieces.create(:type => 'Pawn', :color => "Black", :x_coordinate => p, :y_coordinate => 6)
    end

    # // White Pieces

    # Pawns Row from left to right
    (0..7).each do |p|
    	pieces.create(player_id: white_player.id, :type => 'Pawn', :color => "White", :x_coordinate => p, :y_coordinate => 1)
    end
    # Back Row from left to right
    pieces.create(player_id: white_player.id, :type => 'Rook', :color => "White", :x_coordinate => 0, :y_coordinate => 0)
    pieces.create(player_id: white_player.id, :type => 'Knight', :color => "White", :x_coordinate => 1, :y_coordinate => 0)
    pieces.create(player_id: white_player.id, :type => 'Bishop', :color => "White", :x_coordinate => 2, :y_coordinate => 0)
    pieces.create(player_id: white_player.id, :type => 'King', :color => "White", :x_coordinate => 3, :y_coordinate => 0)
    pieces.create(player_id: white_player.id, :type => 'Queen', :color => "White", :x_coordinate => 4, :y_coordinate => 0)
    pieces.create(player_id: white_player.id, :type => 'Bishop', :color => "White", :x_coordinate => 5, :y_coordinate => 0)
    pieces.create(player_id: white_player.id, :type => 'Knight', :color => "White", :x_coordinate => 6, :y_coordinate => 0)
    pieces.create(player_id: white_player.id, :type => 'Rook', :color => "White", :x_coordinate => 7, :y_coordinate => 0)
  end

  def check_status
    hash = { black: false, white: false }
    %w(Black White).each do |color|
      sym = color.downcase.intern
      if check?(color)
        hash[sym] = player_in_checkmate?(color) ? 'checkmate' : 'check'
      elsif stalemate?(color)
        hash[sym] = 'stalemate'
      end
    end
    hash
  end

  def check?(color)
    king = kings.find_by! color: color
    opponents = pieces.where(color: king.opposite_color)
    opponents.any? do |piece|
      piece.valid_move?(king.x_coordinate, king.y_coordinate)
    end
  end

  def color_turn
    turn.odd? ? 'Black' : 'White'
  end

  def player_turn
    color_turn == 'Black' ? black_player : white_player
  end

  def player_in_checkmate?(color)
    # Determine if the game is in a checkmate state, and increment the player's
    # win/loss accordingly.
    if check?(color) && !player_has_valid_moves?(color)
      winning_player = color == 'White' ? black_player : white_player
      losing_player = color == 'White' ? white_player : black_player

      increment_win_losses(winning_player, losing_player)
      return true
    end
    false
  end

  def increment_win_losses(winner, loser)
    # Don't increment win losses if a player is playing against themself
    unless winner == loser
      # Don't increment win/losses if it has already been done.
      return if game_over
      winner.increment!(:wins)
      loser.increment!(:losses)
      update(game_over: true)
    end
  end

  def player_has_valid_moves?(color)
    players_pieces = pieces.where(color: color)
    players_pieces.each do |piece|
      return true if piece.has_valid_moves?
    end
    false
  end

  def all_board_spaces
    two_d_array = []
    8.times do |x|
      8.times { |y| two_d_array << [x, y] }
    end
    two_d_array
  end

  def stalemate?(color)
    color_turn == color && !check?(color) && !player_has_valid_moves?(color)
  end

  def increment_stalemate
    unless white_player == black_player
      white_player.increment!(:stalemates)
      black_player.increment!(:stalemates)
    end
  end

  def over_by_stalemate(color)
    if stalemate?(color)
      increment_stalemate
      update(game_over: true)
    end
  end

  def started_at
    created_at.strftime('%I:%M %p, %-m/%-d/%Y')
  end

  def other_player_name(player)
    other = black_player if player == white_player
    other = white_player if player == black_player
    other.nil? ? false : other.username
  end
end
