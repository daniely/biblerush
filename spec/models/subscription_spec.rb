require 'rails_helper'

RSpec.describe Subscription, type: :model do
  fixtures :users, :reading_plans, :reading_plan_details, :subscriptions

  let(:kyle) { users(:kyle) }
  let(:plan) { reading_plans(:seven_day_plan) }
  let(:sub) { subscriptions(:kyle_sub) }
  let!(:job) {
    PlanJob.create!(
      subscription_id: sub.id,
      plan_day: 1,
      scheduled_for: DateTime.yesterday,
      sent_at: Time.now.utc
    )
  }
  let!(:job2) { job.create_next_plan_job! }

  describe '#completed_days' do
    context 'multiple plan days with one marked as read' do
      # setup multiple plan days but with only one marked as read
      # day 1, notification #1 - not read
      # day 2, notification #1 - read
      # day 3, notification #1 - not read
      it 'works' do
        job2.update_columns(read_at: Time.now.utc, sent_at: 1.hour.ago)
        job3 = job2.create_next_plan_job!
        expect(sub.completed_days[1].first).to eq(true)
      end
    end

    context 'multiple plan days and none are marked read' do
      it 'works' do
        expect(sub.completed_days[1].first).to eq(false)
        expect(sub.completed_days[1].last).to eq(job2.id)
      end
    end
  end

  describe '#progress' do
    # just testing that it runs without errors
    it 'works' do
      expect(sub.progress).to be
    end
  end
end
