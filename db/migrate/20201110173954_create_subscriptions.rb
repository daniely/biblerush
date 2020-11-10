class CreateSubscriptions < ActiveRecord::Migration[6.0]
  def change
    create_table :subscriptions do |t|
      t.integer :user_id
      t.integer :reading_plan_id
      t.integer :day
      t.datetime :read_on
      t.timestamps
    end

    add_index :subscriptions, :user_id
    add_index :subscriptions, :day
  end
end
