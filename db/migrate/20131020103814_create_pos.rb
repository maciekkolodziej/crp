class CreatePos < ActiveRecord::Migration
  def change
    create_table :pos do |t|
      t.string :name
    end
  end
end
