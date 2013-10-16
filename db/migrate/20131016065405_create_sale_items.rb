class CreateSaleItems < ActiveRecord::Migration
  def change
    create_table :sale_items do |t|
      t.integer :sale_receipt_id
      t.integer :product_id
      t.string :product_name
      t.integer :quantity
      t.decimal :price, :precision => 10, :scale => 2
      t.decimal :value, :precision => 10, :scale => 2
      t.decimal :net_value, :precision => 10, :scale => 2
      t.string :vat_symbol
      t.decimal :vat_rate, :precision => 2, :scale => 2
      t.integer :line_number
    end
    add_index :sale_items, :sale_receipt_id
    add_index :sale_items, :product_id
  end
end
