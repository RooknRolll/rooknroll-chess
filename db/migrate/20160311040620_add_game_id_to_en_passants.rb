class AddGameIdToEnPassants < ActiveRecord::Migration
  def change
    add_column :en_passants, :game_id, :integer
  end
end
