class CrpPosProduct < ActiveRecord::Base
  self.table_name = 'crp_pos_product'
  establish_connection Rails.configuration.database_configuration["crp1"]
  
  belongs_to :crp_product, foreign_key: :product_id
end