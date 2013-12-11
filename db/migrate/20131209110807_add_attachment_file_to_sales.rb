class AddAttachmentFileToSales < ActiveRecord::Migration
  def change
    remove_column :sales, :file_content
    add_attachment :sales, :file
    add_column :sales, :file_fingerprint, :string
  end
end
