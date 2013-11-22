class CreateUnits < ActiveRecord::Migration
  def change
    create_table :units do |t|
      t.string :symbol, limit: 7, null: false
      t.string :name, limit: 45
      t.boolean :primary, null: false, default: false
      
      t.index :symbol
    end
  end
end
