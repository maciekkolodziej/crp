class RenameStoreNameToSymbol < ActiveRecord::Migration
  def change
    rename_column :stores, :name, :symbol
  end
end
