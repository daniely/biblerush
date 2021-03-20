class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:landing, :home, :subscribe, :congratz]

  def landing
    if user_signed_in?
      if Subscription.where(user_id: current_user.id).present?
        redirect_to subscriptions_path
      else
        redirect_to '/welcome'
      end
    end
  end

  def home
  end

  def subscribe
    email = params[:email]
    redirect_to "/users/sign_up?email=#{CGI.escape(email)}"
  end

  def welcome
  end

  def congratz
    @prev_plan_job = PlanJob.find(params[:prev_id])
    @plan_job = if params[:id].present?
                  PlanJob.find(params[:id])
                else
                  PlanJob.none
                end
    @day = @prev_plan_job.plan_day
    @next_day = @day.to_i + 1
  end
end
