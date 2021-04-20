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
      logger.info "sending notification for #{self.id}"
    end
    # mark read
    sent_at = Time.now.utc
    save!
    # create next PlanJob entry
    create_next_plan_job!
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
  def self.get_emailable
    self.joins(:subscription)
        .where(sent_at: nil, read_at: nil)
        .where("scheduled_for <= ?", Time.now.utc)
        .where(subscriptions: { active: true })
  end

  # send reading plan job emails every NNN minutes/hours/day
  def self.send_email_notifications
    self.get_emailable.each do |plan_job|
      plan_job.send_notification
    end
  end
end
