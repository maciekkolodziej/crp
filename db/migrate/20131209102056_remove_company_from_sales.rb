class RemoveCompanyFromSales < ActiveRecord::Migration
  def change
    remove_column :sales, :company_id
  end
end
