class SubscriptionsController < ApplicationController
  def create
    subscription = Beesly.new.create_subscription(user_id: params[:user_id], reading_plan_id: params[:plan_id])
    redirect_to subscription_path(id: subscription.id)
  end

  def index
    @subscriptions = Subscription.where(user_id: current_user.id)
  end

  def show
    @subscription = Subscription.find_by(id: params[:id])
    #[true/false, plan_job id]
    completed_days = {}.tap do |h|
      @subscription.plan_jobs.map{ |job| h[job.plan_day] = [job.read_at.present?, job.id] }
    end
    # array of [day, passage ref, completed_days]
    # completed_days => nil=no job  true=day has been read  false=day not read yet
    @progress = @subscription.reading_plan.reading_plan_details.order(:day).map{ |a|
      [a.day, a.detailed_reference, completed_days[a.day].try(:[], 0), completed_days[a.day].try(:[], 1)]
    }

    if @subscription.user.id != current_user.id
      redirect_to user_root_path
    end
  end
end
