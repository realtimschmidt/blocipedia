class AddUserIdToCollaborators < ActiveRecord::Migration
  def change
    add_column :collaborators, :user_id, :integer
  end
end
