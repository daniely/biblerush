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
        UserMailer.plan_job(plan_job.id).deliver_now
      end
    end
    sub
  end

  # if this is last day of plan
  #   mark the subscription complete (incomplete)
  # else
  #   if current plan has been read
  #     send next day's passages
  #   else
  #     send same day passage
  #   end
  # end
  def schedule_next_reading(plan_job_id:)
    job = PlanJob.find(plan_job_id)
    plan_day = job.plan_day
    next_plan_day = plan_day + 1
    max_days = job.subscription.reading_plan.days
    is_reading_plan_done = plan_day == max_days
    if is_reading_plan_done
      job.subscription.active = false
      job.subscription.save!
    else
      schedule_for = Time.now.utc + 1.day
      set_plan_day = if job.read_at.blank?
                       plan_day
                     else
                       next_plan_day
                     end
      # TODO: schedule for next day at same `send_at` time
      job.subscription.plan_jobs.create(
        plan_day: set_plan_day,
        scheduled_for: schedule_for
      )
      # TODO: schedule the worker
    end
    job.save!
  end

  # mark read and then schedule next reading
  def mark_read!(plan_job_id:)
    job = PlanJob.find(plan_job_id)
    job.read_at = Time.now.utc
    job.save!

    # schedule next reading
    schedule_next_reading(plan_job_id: plan_job_id)
  end
end
