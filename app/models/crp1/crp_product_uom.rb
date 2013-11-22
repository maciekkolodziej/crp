class CrpProductUom < ActiveRecord::Base
  self.table_name = 'crp_product_uom'
  establish_connection Rails.configuration.database_configuration["crp1"]
end