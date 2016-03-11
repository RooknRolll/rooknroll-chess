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
    	pieces.create(:type => 'Pawn', :color => "White", :x_coordinate => p, :y_coordinate => 1)
    end
    # Back Row from left to right
    pieces.create(:type => 'Rook', :color => "White", :x_coordinate => 0, :y_coordinate => 0)
    pieces.create(:type => 'Knight', :color => "White", :x_coordinate => 1, :y_coordinate => 0)
    pieces.create(:type => 'Bishop', :color => "White", :x_coordinate => 2, :y_coordinate => 0)
    pieces.create(:type => 'King', :color => "White", :x_coordinate => 3, :y_coordinate => 0)
    pieces.create(:type => 'Queen', :color => "White", :x_coordinate => 4, :y_coordinate => 0)
    pieces.create(:type => 'Bishop', :color => "White", :x_coordinate => 5, :y_coordinate => 0)
    pieces.create(:type => 'Knight', :color => "White", :x_coordinate => 6, :y_coordinate => 0)
    pieces.create(:type => 'Rook', :color => "White", :x_coordinate => 7, :y_coordinate => 0)
  end

  def check?(king, piece)
    if king.color != piece.color && piece.valid_move?(king.x_coordinate, king.y_coordinate)
      # Message to display: The piece.color piece.type has your King in check!
      true
    else
      false
    end
  end
end
