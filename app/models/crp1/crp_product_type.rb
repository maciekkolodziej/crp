class CrpProductType < ActiveRecord::Base
  self.table_name = 'crp_product_type'
  establish_connection Rails.configuration.database_configuration["crp1"]
end