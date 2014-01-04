class CreateTakings < ActiveRecord::Migration
  def change
    create_table :takings do |t|
      t.integer :store_id, null: false, default: false
      t.date :date, null: false, default: false
      t.decimal :value, precision: 10, scale: 2, null: false
      t.decimal :card_payments, precision: 10, scale: 2, null: false
      t.decimal :cash_payments, precision: 10, scale: 2
      
      t.userstamps
      t.timestamps
      
      t.foreign_key :stores, dependent: :restrict, options: "ON UPDATE CASCADE"
    end
  end
end
