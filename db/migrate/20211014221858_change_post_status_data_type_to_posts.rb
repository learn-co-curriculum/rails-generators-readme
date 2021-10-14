class ChangePostStatusDataTypeToPosts < ActiveRecord::Migration[5.0]
  def change
    change_column :posts, :post_status, :string
  end
end
