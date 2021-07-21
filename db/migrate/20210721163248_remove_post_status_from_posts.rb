class RemovePostStatusFromPosts < ActiveRecord::Migration[5.0]
  def change
    remove_column :posts, :post_status, :
  end
end
