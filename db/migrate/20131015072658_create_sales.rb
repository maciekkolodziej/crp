class CreateSales < ActiveRecord::Migration
  def change
    create_table :sales do |t|
      t.integer :company_id
      t.integer :pos_id
      t.date :date
      t.integer :number
      t.decimal :value
      t.decimal :vat
      t.decimal :net_value
      t.decimal :cash
      t.integer :receipt_count
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
  end
end
