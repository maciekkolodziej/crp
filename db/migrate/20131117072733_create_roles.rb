class CreateRoles < ActiveRecord::Migration
  def change
    create_table :roles do |t|
      t.string :name
      t.boolean :global, default: false, null: false
    end
  end
end
