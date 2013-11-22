class CreateProductCategories < ActiveRecord::Migration
  def change
    create_table :product_categories do |t|
      t.integer :symbol
      t.string :name, limit: 45
    end
  end
end
