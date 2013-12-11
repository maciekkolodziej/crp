class AddRegisterHeaderToStore < ActiveRecord::Migration
  def change
    add_column :stores, :register_header, :string
  end
end
