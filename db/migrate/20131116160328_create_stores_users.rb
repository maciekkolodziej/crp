class CreateStoresUsers < ActiveRecord::Migration
  def change
    create_table :stores_users do |t|
      t.belongs_to :store
      t.belongs_to :user
    end
  end
end
