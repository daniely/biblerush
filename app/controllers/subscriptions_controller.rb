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
    completed_days = @subscription.plan_jobs.map(&:plan_day)
    # array of [day, passage ref, completed]
    @progress = @subscription.reading_plan.reading_plan_details.map{ |a|
      [a.day, a.detailed_reference, completed_days.include?(a.day)]
    }

    if @subscription.user.id != current_user.id
      redirect_to user_root_path
    end
  end
end
