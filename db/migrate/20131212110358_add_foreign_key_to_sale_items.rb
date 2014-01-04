class AddForeignKeyToSaleItems < ActiveRecord::Migration
  def change
    add_foreign_key :sale_items, :products, dependent: :nullify, options: "ON UPDATE CASCADE"
  end
end
