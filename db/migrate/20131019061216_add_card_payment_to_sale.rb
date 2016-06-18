class AddCardPaymentToSale < ActiveRecord::Migration
  def change
    add_column :sales, :card_payments, :decimal, after: :vat, :precision => 10, :scale => 2
  end
end
