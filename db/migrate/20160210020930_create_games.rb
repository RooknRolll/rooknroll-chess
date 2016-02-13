class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.belongs_to :black_player
      t.belongs_to :white_player
      t.timestamps
    end
  end
end
