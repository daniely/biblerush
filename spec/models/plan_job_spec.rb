require 'rails_helper'

RSpec.describe PlanJob, type: :model do
  fixtures :users, :reading_plans, :reading_plan_details

  let(:kyle) { users(:kyle) }
  let(:plan) { reading_plans(:seven_day_plan) }
  let(:sub) {
    Subscription.create!(
      user_id: kyle.id,
      reading_plan_id: plan.id,
      send_at: Date.tomorrow,
      active: true
    )
  }

  describe '#next_plan_day' do
    let(:job) {
      described_class.create!(
        subscription_id: sub.id,
        plan_day: 1
      )
    }

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
        let(:job7) {
          described_class.create!(
            subscription_id: sub.id,
            plan_day: 7
          )
        }

        it 'gets next day' do
          expect(job7.plan_day).to eq(7)
          expect(job7.next_plan_day).to eq(nil)
        end
      end
    end
  end
end
