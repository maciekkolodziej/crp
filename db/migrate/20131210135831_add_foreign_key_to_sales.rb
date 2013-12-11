class AddForeignKeyToSales < ActiveRecord::Migration
  def change
    add_foreign_key :sales, :stores, dependent: :restrict, options: "ON UPDATE CASCADE"
  end
end
