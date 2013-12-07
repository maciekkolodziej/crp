class CrpProduct < ActiveRecord::Base
  self.table_name = 'crp_product'
  establish_connection Rails.configuration.database_configuration["crp1"]
end