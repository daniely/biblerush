# the "office admin" helps create and manage reading plan schedules
class Beesly
  def create_subscription(user_id:, reading_plan_id:, send_email: true)
    user = User.find(user_id)
    now = Time.now.utc
    sub = Subscription.create(
      user_id: user_id,
      reading_plan_id: reading_plan_id,
      send_at: now,
      active: true
    )
    if sub.save
      # log that notification was sent
      plan_job = sub.plan_jobs.create(
        plan_day: 1,
        scheduled_for: now,
        sent_at: now
      )

      if send_email
        UserMailer.plan_job_full(plan_job.id).deliver_now
      end
    end
    sub
  end

  def schedule_next_reading(plan_job_id:)
    job = PlanJob.find(plan_job_id)
    next_job = nil
    if job.next_plan_day.present?
      schedule_for = Time.now.utc + 1.day
      set_plan_day = if job.read_at.blank?
                       job.plan_day
                     else
                       job.next_plan_day
                     end
      # TODO: schedule for next day at same `send_at` time
      next_job = job.subscription.plan_jobs.create(
        plan_day: set_plan_day,
        scheduled_for: schedule_for
      )
      # TODO: schedule the worker
    # we're done reading!
    else
      job.subscription.active = false
      job.subscription.save!
    end
    job.save!

    UserMailer.plan_job_full(next_job.id).deliver_now if next_job.present?
    # return next_job so we can use it
    next_job
  end

  # mark read and then schedule next reading (and return the next reading plan_job)
  def mark_read!(plan_job_id:)
    job = PlanJob.find(plan_job_id)
    next_plan_job = if job.read_at.blank?
                      job.read_at = Time.now.utc
                      job.save!
                      # schedule next reading
                      schedule_next_reading(plan_job_id: plan_job_id)
                    else
                      job
                    end
    next_plan_job
  end
end
