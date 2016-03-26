class AddGameOverToGame < ActiveRecord::Migration
  def change
    add_column :games, :game_over, :boolean, default: false
  end
end
