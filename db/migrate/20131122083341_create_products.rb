class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :name, limit: 45,                  null: false
      t.integer :unit_id,         default: 1,     null: false
      t.boolean :active,          default: true,  null: false
      
      t.boolean :purchasable,     default: false, null: false
      t.boolean :inventoried,     default: false, null: false
      t.decimal :cost_price, precision: 10, scale: 2
      
      t.boolean :sellable,        default: false, null: false
      t.integer :register_code, precision: 4
      t.string :register_name, limit: 18
      t.integer :category_id
      t.integer :vat_rate_id

      t.timestamps
      t.userstamps
      
      t.index :register_code
      t.index :register_name
      t.index :active
      
      t.foreign_key :units, dependent: :restrict, options: "ON UPDATE CASCADE"
      t.foreign_key :product_categories, column: :category_id, dependent: :nullify, options: "ON UPDATE CASCADE"
      t.foreign_key :vat_rates, dependent: :restrict, options: "ON UPDATE CASCADE"
    end
  end
end
