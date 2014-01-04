class CreateDatabaseReset < ActiveRecord::Migration
  def change
    create_table :database_resets do |t|
      t.string :ip
      t.string :hostname
      t.timestamps
    end
  end
end
