class RenameCancelledReceipts < ActiveRecord::Migration
  def change
    rename_column :sales, :cancelled_receipt_count, :cancelled_receipts_count
    rename_column :sales, :cancelled_receipt_value, :cancelled_receipts_value
    rename_column :sales, :receipt_count, :receipts_count
  end
end
