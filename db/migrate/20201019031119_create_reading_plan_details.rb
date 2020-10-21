class CreateReadingPlanDetails < ActiveRecord::Migration[6.0]
  def change
    create_table :reading_plan_details do |t|
      t.integer :reading_plan_id
      t.text :plan
      t.text :detailed_plan
      t.integer :day
      t.timestamps
    end
  end
end
