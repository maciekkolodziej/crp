class CreateSaleReceipts < ActiveRecord::Migration
  def change
    create_table :sale_receipts do |t|
      t.integer :sale_id
      t.integer :number
      t.datetime :datetime
      t.decimal :value, :precision => 10, :scale => 2
      t.decimal :net_value, :precision => 10, :scale => 2
      t.integer :item_count
      t.boolean :cancelled
      t.integer :salesman_id
      t.integer :begins_at_line
      t.integer :ends_at_line
    end
    add_index :sale_receipts, :sale_id
  end
end
