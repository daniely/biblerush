class Subscription < ApplicationRecord
  belongs_to :user
  belongs_to :reading_plan
  has_many :plan_jobs
end
