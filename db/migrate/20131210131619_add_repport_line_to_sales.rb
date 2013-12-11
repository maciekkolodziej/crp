class AddRepportLineToSales < ActiveRecord::Migration
  def change
    add_column :sales, :report_line, :integer
  end
end
