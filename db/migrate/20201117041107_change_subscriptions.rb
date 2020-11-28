class ChangeSubscriptions < ActiveRecord::Migration[6.0]
  def change
    remove_column :subscriptions, :day
    remove_column :subscriptions, :read_on
    add_column :subscriptions, :send_at, :time
    add_column :subscriptions, :active, :boolean, default: true, null: false
    add_index :subscriptions, :active
  end
end
