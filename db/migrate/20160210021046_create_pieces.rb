class CreatePieces < ActiveRecord::Migration
  def change
    create_table :pieces do |t|
      t.string :type
      t.string :color
      t.integer :x_coordinate
      t.integer :y_coordinate
      t.belongs_to :game
      t.belongs_to :player

      t.timestamps
    end
  end
end
