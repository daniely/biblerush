class PlanJobsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:show]

  def show
    @plan_job = PlanJob.find(params[:id])
    @reading_plan_detail = @plan_job.subscription.reading_plan.reading_plan_details.find_by(day: @plan_job.plan_day)
  end

  def mark_read
    plan_job = PlanJob.find(params[:plan_job_id])
    Beesly.new.mark_read!(plan_job_id: plan_job.id)
    redirect_to progress_path(sid: plan_job.subscription_id)
  end
end
