class CreatePlanJobs < ActiveRecord::Migration[6.0]
  enable_extension 'pgcrypto' unless extension_enabled?('pgcrypto')

  def change
    create_table :plan_jobs, id: :uuid, default: 'gen_random_uuid()' do |t|
      t.integer :subscription_id
      t.integer :plan_day
      t.datetime :scheduled_for
      t.datetime :sent_at
      t.datetime :read_at
      t.timestamps
    end
  end
end
