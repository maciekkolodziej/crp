class CreateVatRates < ActiveRecord::Migration
  def change
    create_table :vat_rates do |t|
      t.string :symbol, :limit => 1
      t.decimal :rate, :precision => 3, :scale => 2
    end
  end
end
