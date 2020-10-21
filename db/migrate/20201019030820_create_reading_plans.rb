class CreateReadingPlans < ActiveRecord::Migration[6.0]
  def change
    create_table :reading_plans do |t|
      t.text :plan_name
      t.text :description
      t.integer :days
      t.timestamps
    end
  end
end
