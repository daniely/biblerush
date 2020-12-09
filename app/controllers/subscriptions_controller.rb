class SubscriptionsController < ApplicationController
  def create
    Beesly.new.create_subscription(user_id: params[:user_id], reading_plan_id: params[:plan_id])
    redirect_to progress_path
  end
end
