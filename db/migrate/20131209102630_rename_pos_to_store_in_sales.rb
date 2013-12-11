class RenamePosToStoreInSales < ActiveRecord::Migration
  def change
    rename_column :sales, :pos_id, :store_id
  end
end
