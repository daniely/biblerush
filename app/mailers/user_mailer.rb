class UserMailer < ApplicationMailer
  PLAN_T_ID = 'd-d2c767ccd7e24a94bb842b40b9985c6a'

  def plan_job(id)
    plan_job = PlanJob.find(id)
    subscription = plan_job.subscription
    reading_plan = subscription.reading_plan
    reading_plan_detail = reading_plan.reading_plan_details.find_by(day: plan_job.plan_day)
    # NOTE: if 'body' param is not included rails will look for a matching `view` so include it for now
    mail(
      to: subscription.user.email,
      body: 'placeholder body',
      template_id: PLAN_T_ID,
      dynamic_template_data: {
        reading_plan_name: reading_plan.plan_name,
        day_number: plan_job.plan_day,
        passage_reference: reading_plan_detail.detailed_reference,
        plan_job_id: plan_job.id
      }
    )
  end

  def plan_job_full(id)
    @plan_job = PlanJob.find(id)
    @subscription = @plan_job.subscription
    @reading_plan = @subscription.reading_plan
    @reading_plan_detail = @reading_plan.reading_plan_details.find_by(day: @plan_job.plan_day)
    subject = "#{@reading_plan.plan_name} | Day #{@plan_job.plan_day}"
    # HACK: include dynamic_template_data to remove unsubscribe link
    mail(
      to: @subscription.user.email,
      from: 'hello@biblerush.com',
      subject: subject,
      dynamic_template_data: {
        test: 'test'
      }
    )
  end
end
