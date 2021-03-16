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
  end
end
