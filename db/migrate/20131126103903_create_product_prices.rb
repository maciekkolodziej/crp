class CreateProductPrices < ActiveRecord::Migration
  def change
    create_table :product_prices do |t|
      t.integer :store_id, null: false
      t.integer :product_id, null: false
      t.decimal :sale_price, precision: 10, scale: 2, null: false

      t.timestamps
      t.userstamps
      
      t.foreign_key :stores, dependent: :delete, options: "ON UPDATE CASCADE"
      t.foreign_key :products, dependent: :delete, options: "ON UPDATE CASCADE"
      
      t.index [:store_id, :product_id], unique: true
    end
  end
end
