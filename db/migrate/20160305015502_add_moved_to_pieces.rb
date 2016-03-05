class AddMovedToPieces < ActiveRecord::Migration
  def change
    add_column :pieces, :moved, :boolean, default: false
  end
end
