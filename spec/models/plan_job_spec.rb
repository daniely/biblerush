require 'rails_helper'

RSpec.describe PlanJob, type: :model do
  fixtures :users, :reading_plans, :reading_plan_details, :subscriptions

  let(:kyle) { users(:kyle) }
  let(:plan) { reading_plans(:seven_day_plan) }
  let(:sub) { subscriptions(:kyle_sub_7_day) }
  let(:sub2) { subscriptions(:kyle_sub_2_day) }
  let!(:job) {
    described_class.create!(
      subscription_id: sub.id,
      plan_day: 1,
      scheduled_for: DateTime.yesterday
    )
  }

  describe '#send_notification' do
    it "updates 'sent_at'" do
      expect(job.sent_at).to_not be
      job.send_notification
      expect(job.sent_at).to be
    end
  end

  describe '#create_next_plan_job!' do
    context 'job notification not sent yet' do
      it 'does not create another notification job for same passage/day' do
        expect do
          job.create_next_plan_job!
        end.to change{described_class.count}.by(0)
      end
    end

    context 'job notification already sent' do
      before do
        job.sent_at = DateTime.now
      end

      it 'creates another notification job for same passage/day' do
        new_job = nil
        expect do
          new_job = job.create_next_plan_job!
        end.to change{described_class.count}.by(1)

        expect(new_job.plan_day).to eq(job.plan_day)
        expect(new_job.subscription_id).to eq(job.subscription_id)
        expect(new_job.sent_at).to eq(nil)
        expect(new_job.read_at).to eq(nil)
        expect(new_job.scheduled_for).to be_within(1.day).of(Time.now)
        expect(new_job.scheduled_for).to_not be_within(30.minutes).of(Time.now)
      end
    end
  end

  describe '.send_email_notifications' do
    it 'sends email notification and schedules next notification jobs' do
      expect_any_instance_of(described_class).to receive(:send_notification)
      expect_any_instance_of(described_class).to receive(:create_next_plan_job!)
      described_class.send_email_notifications
    end
  end

  describe '.get_emailable' do
    it 'works' do
      results = described_class.get_emailable
      result = results.first
      expect(results.count).to eq(1)
      expect(result.sent_at).to eq(nil)
      expect(result.read_at).to eq(nil)
      expect(result.scheduled_for).to be <= Time.now.utc
      expect(result.subscription.active).to eq(true)
    end

    context "'scheduled_for' is all in the future" do
      before do
        described_class.update_all(scheduled_for: DateTime.tomorrow)
      end

      it 'finds no matches' do
        expect(described_class.get_emailable.count).to eq(0)
      end
    end

    context "'subscription' are all inactive" do
      before do
        Subscription.update_all(active: false)
      end

      it 'finds no matches' do
        expect(described_class.get_emailable.count).to eq(0)
      end
    end

    context "multiple jobs for same day with middle job marked read" do
      it 'find no matches' do
        job.update_columns(sent_at: 3.hours.ago)
        job2 = job.create_next_plan_job!
        job2.update_columns(sent_at: 2.hour.ago, read_at: Time.now.utc)
        job3 = job.create_next_plan_job!
        job3.update_columns(scheduled_for: 2.hours.ago)
        expect(described_class.get_emailable.count).to eq(0)
      end
    end

    context 'jobs for two different plans (subscriptions)' do
      before do
        sub2.plan_jobs.create!(
          plan_day: 1,
          scheduled_for: DateTime.yesterday
        )
      end

      it 'emails for both plans' do
        expect(described_class.get_emailable.count).to eq(2)
      end

      context 'one plan has first two days read, another plan has first day only read with second day scheduled' do
        it 'emails for both plans' do
          beesly = Beesly.new
          jobs1 = sub.plan_jobs
          jobs2 = sub2.plan_jobs
          # job 1 - mark day 1 and day 2 read
          beesly.mark_read!(plan_job_id: jobs1.last.id)
          job1_next = beesly.schedule_next_reading(plan_job_id: jobs1.last.id)
          beesly.mark_read!(plan_job_id: job1_next.id)
          beesly.schedule_next_reading(plan_job_id: job1_next.id)

          # job 2 - mark day 1 read
          beesly.mark_read!(plan_job_id: jobs2.last.id)
          beesly.schedule_next_reading(plan_job_id: jobs2.last.id)
          # make sure `scheduled_for` doesn't filter out plans we need to notify
          PlanJob.update_all(scheduled_for: 1.day.ago)
          jobs = described_class.get_emailable
          expect(jobs.count).to eq(2)
          expect(jobs.find{ |j| j.subscription_id == sub.id  }.plan_day).to eq(3)
          expect(jobs.find{ |j| j.subscription_id == sub2.id }.plan_day).to eq(2)
        end
      end
    end
  end

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
