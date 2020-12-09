class PlanJobsController < ApplicationController
  def show
    plan_job = PlanJob.find(params[:id])
    @reading_plan_detail = plan_job.subscription.reading_plan.reading_plan_details.find_by(day: plan_job.plan_day)
  end
end
