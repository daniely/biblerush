# to keep track of reading plan email scheduled jobs
#
# if `sent_at` is nil we know the job exists but didn't send out yet
class PlanJob < ApplicationRecord
  self.implicit_order_column = "created_at"
  belongs_to :subscription
end
