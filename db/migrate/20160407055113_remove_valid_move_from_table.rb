class RemoveValidMoveFromTable < ActiveRecord::Migration
  def change
    remove_column :pieces, :valid_move, :boolean
  end
end
