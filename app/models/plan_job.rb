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
end
