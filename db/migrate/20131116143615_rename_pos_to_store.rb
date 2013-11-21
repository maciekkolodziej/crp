class RenamePosToStore < ActiveRecord::Migration
  def change
    rename_table :pos, :stores
  end
end
