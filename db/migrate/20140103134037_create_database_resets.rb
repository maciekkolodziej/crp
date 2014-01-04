class CreateDatabaseResets < ActiveRecord::Migration
  def change
    create_table :database_resets do |t|
      t.string :ip
      t.string :hostname
      t.datetime :created_at
      t.datetime :updated_at

      t.timestamps
    end
  end
end
