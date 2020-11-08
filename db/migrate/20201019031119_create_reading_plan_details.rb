class CreateReadingPlanDetails < ActiveRecord::Migration[6.0]
  def change
    create_table :reading_plan_details do |t|
      t.integer :reading_plan_id
      t.text :reference
      t.text :detailed_reference
      t.integer :day
      t.text :passages, array: true, default: []
      t.timestamps
    end

    add_index :reading_plan_details, :reading_plan_id
    add_index :reading_plan_details, [:reading_plan_id, :day]
  end
end
