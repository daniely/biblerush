class SubscriptionsController < ApplicationController
  def create
    subscription = Beesly.new.create_subscription(user_id: params[:user_id], reading_plan_id: params[:plan_id])
    redirect_to progress_path(sid: subscription.id)
  end
end
