# to keep track of reading plan email scheduled jobs
#
# it's expected there will be multiple PlanJob entries for the same passage/day - for
# when people do not read their passages.
#
# we allow multiple PlanJob entries for stats and metrics
#
# if `sent_at` is nil we know the job exists but didn't send out yet
#
# but if `sent_at` is nil while `read_at` is present, it means we never sent out
# a reading plan email but they directly read it from the website. do not send emails
# for plans that have been read.
#
# might be better to rename this NotificationJob ???
class PlanJob < ApplicationRecord
  self.implicit_order_column = "created_at"
  belongs_to :subscription

  # helper method so we don't end up with circular dependencies
  def reading_plan_detail
    subscription.reading_plan.reading_plan_details.find_by(day: plan_day)
  end

  # return either the next plan day, or nil if at end of reading plan
  def next_plan_day
    total_days = subscription.reading_plan.days
    if plan_day < total_days
      return plan_day + 1
    else
      return nil
    end
  end

  def send_notification
    Rails.logger.tagged("PlanJob#send_notification") do
      Rails.logger.info "sending notification for #{self.id}"
    end
    self.update_column(:sent_at, Time.now.utc)
    # send email
    UserMailer.plan_job_full(self.id).deliver_now
  end

  # create a duplicate PlanJob entry to send the next day
  def create_next_plan_job!
    # TODO: move this check into validation and maybe into schema too
    return if sent_at.blank?

    subscription.plan_jobs.create!(
      plan_day: plan_day,
      scheduled_for: Beesly::SCHEDULE_DELAY.after
    )
  end

  # send email for PlanJob where `sent_at` and `read_at` is nil
  # and enough time has passed since `scheduled_for`
  # and subscription is active
  # AND
  # remove subscription/plan_days that are already read
  def self.get_emailable
    # subscription and plan_days that are already read
    already_read_subs_day = self.joins(:subscription)
                               .where(subscriptions: { active: true })
                               .where.not(read_at: nil)
                               .map{ |j| [j.subscription_id, j.plan_day] }
    jobs = self.joins(:subscription)
               .where(sent_at: nil, read_at: nil)
               .where("scheduled_for <= ?", Time.now.utc)
               .where(subscriptions: { active: true })
    # remove any plan days that are already read
    jobs.reject{ |j|
      already_read_subs_day.map(&:first).include?(j.subscription_id) &&
        already_read_subs_day.map(&:last).include?(j.plan_day)
    }
  end

  # send reading plan job emails every NNN minutes/hours/day
  def self.send_email_notifications
    self.get_emailable.find_each do |plan_job|
      plan_job.send_notification
      plan_job.create_next_plan_job!
    end
  end
end
