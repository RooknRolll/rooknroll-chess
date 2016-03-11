class EnPassant < ActiveRecord::Base
  belongs_to :piece
  belongs_to :game

  def self.find_by_coordinates(x, y)
    where(x_coordinate: x, y_coordinate: y).first
  end

  def capture
  end
end
