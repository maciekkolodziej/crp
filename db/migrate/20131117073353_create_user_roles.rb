class CreateUserRoles < ActiveRecord::Migration
  def change
    create_table :user_roles do |t|
      t.integer :user_id, null: false
      t.integer :role_id, null: false
      t.integer :store_id

      t.timestamps
    end
  end
end
