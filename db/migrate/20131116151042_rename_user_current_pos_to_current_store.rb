class RenameUserCurrentPosToCurrentStore < ActiveRecord::Migration
  def change
    rename_column :users, :current_pos_id, :current_store_id
  end
end
