class RemoveCashAndCardPaymentsFromSales < ActiveRecord::Migration
  def change
    remove_column :sales, :cash_payments
    remove_column :sales, :card_payments
  end
end
