require 'rails_helper'

RSpec.describe PlanJob, type: :model do
  let(:user) {
    User.create!(
      email: 'test@test.com',
      password: 'lkjhlkjh'
    )
  }
  let(:plan) {
    ReadingPlan.create!(
      plan_name: 'plan 1',
      description: 'plan desc',
      days: 3
    )
  }
  let(:sub) {
    Subscription.create!(
      user_id: user.id,
      reading_plan_id: plan.id,
      send_at: Date.tomorrow,
      active: true
    )
  }
  let(:job) {
    described_class.create!(
      subscription_id: sub.id,
      plan_day: 1
    )
  }

  describe '#next_plan_day' do
    it 'gets next day' do
      expect(job.plan_day).to eq(1)
      expect(job.next_plan_day).to eq(2)
    end

    context 'on a middle day' do
      let(:job2) {
        described_class.create!(
          subscription_id: sub.id,
          plan_day: 2
        )
      }

      it 'gets next day' do
        expect(job2.plan_day).to eq(2)
        expect(job2.next_plan_day).to eq(3)
      end

      context 'on last day' do
        let(:job3) {
          described_class.create!(
            subscription_id: sub.id,
            plan_day: 3
          )
        }

        it 'gets next day' do
          expect(job3.plan_day).to eq(3)
          expect(job3.next_plan_day).to eq(nil)
        end
      end
    end
  end
end
