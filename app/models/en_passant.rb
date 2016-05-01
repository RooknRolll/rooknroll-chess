class EnPassant < ActiveRecord::Base
  belongs_to :piece
  belongs_to :game

  scope :of_color, ->(given_color) { where(color: given_color) }

  def self.find_by_coordinates(x, y)
    where(x_coordinate: x, y_coordinate: y).first
  end

  def capture
    piece.destroy if piece.type = 'Pawn'
  end
end
