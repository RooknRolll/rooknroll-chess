class AddUsernameToPlayers < ActiveRecord::Migration
  def change
    add_column :players, :username, :string
    add_index :players, :username, unique: true
  end
end
