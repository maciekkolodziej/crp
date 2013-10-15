class CreateSales < ActiveRecord::Migration
  def change
    create_table :sales do |t|
      t.integer :company_id
      t.integer :pos_id
      t.date :date
      t.integer :number
      t.decimal :value, :precision => 10, :scale => 2
      t.decimal :vat, :precision => 10, :scale => 2
      t.decimal :cash, :precision => 10, :scale => 2
      t.integer :receipt_count
      t.binary :file_content, :limit => 10.megabyte
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
  end
end
