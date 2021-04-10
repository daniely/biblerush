class AddCompletedAtToSubscriptions < ActiveRecord::Migration[6.0]
  def change
    add_column :subscriptions, :completed_at, :datetime
  end
end
