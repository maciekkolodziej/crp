class AddCancelledReceiptToSale < ActiveRecord::Migration
  def change
    add_column :sales, :cancelled_receipt_count, :integer, after: :receipt_count
    add_column :sales, :cancelled_receipt_value, :decimal, after: :cancelled_receipt_count, :precision => 10, :scale => 2
  end
end
