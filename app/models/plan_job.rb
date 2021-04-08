# to keep track of reading plan email scheduled jobs
#
# if `sent_at` is nil we know the job exists but didn't send out yet
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
