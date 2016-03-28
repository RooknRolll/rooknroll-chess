class AddTurnToGames < ActiveRecord::Migration
  def change
    add_column :games, :turn, :integer, default: 0
  end
end
