class CreateEnPassants < ActiveRecord::Migration
  def change
    create_table :en_passants do |t|
      t.integer :x_coordinate
      t.integer :y_coordinate
      t.string :color
      t.integer :piece_id
      t.timestamps
    end
  end
end
