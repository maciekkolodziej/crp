class CreateProductAliases < ActiveRecord::Migration
  def change
    create_table :product_aliases do |t|
      t.integer :product_id
      t.string :alias, limit: 18

      t.foreign_key :products, dependent: :delete, options: "ON UPDATE CASCADE"
    end
  end
end
