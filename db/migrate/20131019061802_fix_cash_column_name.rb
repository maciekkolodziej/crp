class FixCashColumnName < ActiveRecord::Migration
  def change
    rename_column :sales, :cash, :cash_payments
  end
end
