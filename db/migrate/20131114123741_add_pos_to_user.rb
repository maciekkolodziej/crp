class AddPosToUser < ActiveRecord::Migration
  def change
    add_column :users, :current_pos_id, :integer
  end
end
