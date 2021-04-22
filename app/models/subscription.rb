class Subscription < ApplicationRecord
  belongs_to :user
  belongs_to :reading_plan
  has_many :plan_jobs

  # hash of [true/false, plan_job id]
  # plan job ID - either the job with `read_at` present or most recent job
  #
  # e.g {1=>[true, "3c528950-e48c-44cb-affa-85bbb0474348"], 2=>[false, "d3ccb63d-0910-4192-8387-fc91bb18a76a"]}
  #
  # day 1 - job with `read_at` present
  # day 2 - most recent job
  def completed_days
    #read = plan_jobs.where.not(read_at: nil).group(:plan_day).maximum(:read_at).transform_values{ |v|
      #[true, v]
    #}
    #unread = plan_jobs.where(read_at: nil).group(:plan_day).maximum(:sent_at).transform_values{ |v|
      #[false, v]
    #}
    #read.merge(unread)
    {}.tap do |h|
      plan_jobs.map(&:plan_day).uniq.map{ |i|
        job = plan_jobs.where(plan_day: i).where.not(read_at: nil).first || plan_jobs.where(plan_day: i).last
        h[i] = [job.read_at.present?, job.id]
      }
    end
  end

  # [
  #   plan day,
  #   passage reference,
  #   true/false/nil,
  #   plan ID
  # ]
  # completed_days => nil=no job  true=day has been read  false=day not read yet
  def progress
    cd = completed_days
    self.reading_plan.reading_plan_details.order(:day).map{ |a|
      [a.day, a.detailed_reference, cd[a.day].try(:[], 0), cd[a.day].try(:[], 1)]
    }
  end
end
