class CrpProductCategory < ActiveRecord::Base
  self.table_name = 'crp_product_category'
  establish_connection Rails.configuration.database_configuration["crp1"]
end