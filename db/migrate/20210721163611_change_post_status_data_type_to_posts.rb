class ChangePostStatusDataTypeToPosts < ActiveRecord::Migration[5.0]
  def change
    change_column :posts, :post_status, :string
    #Ex:- change_column("admin_users", "email", :string, :limit =>25)
  end
end
