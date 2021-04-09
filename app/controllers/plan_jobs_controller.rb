class PlanJobsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:show, :mark_read]
  skip_before_action :verify_authenticity_token, only: [:mark_read]

  def show
    plan_job_id = params[:id]
    @plan_job = if plan_job_id.present?
                  PlanJob.find_by(id: plan_job_id)
                else
                  PlanJob.where(user_id: current_user.id, active: true).last
                end
    if @plan_job.present?
      @reading_plan_detail = @plan_job.reading_plan_detail
    else
      redirect_to root_path
    end
  end

  def mark_read
    plan_job = PlanJob.find(params[:plan_job_id])
    next_job = Beesly.new.mark_read!(plan_job_id: plan_job.id)
    redirect_to congratz_path(id: next_job.try(:id), prev_id: plan_job.id)
  end
end
