class EnPassant < ActiveRecord::Base
  belongs_to :pawn

  def self.find_by_coordinates(x, y)
    where(x_coordinate: x, y_coordinate: y).first
  end
end
