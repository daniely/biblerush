class SubscriptionsController < ApplicationController
  def create
    subscription = Beesly.new.create_subscription(user_id: params[:user_id], reading_plan_id: params[:plan_id])
    redirect_to subscription_path(id: subscription.id)
  end

  def index
    subscriptions = Subscription.where(user_id: current_user.id).order(:id)
    @finished = subscriptions.where.not(completed_at: nil)
    @active = subscriptions.where(active: true) - @finished
    @paused = subscriptions.where(active: false) - @finished
  end

  def show
    @subscription = Subscription.find_by(id: params[:id])
    # [
    #   plan day,
    #   passage reference,
    #   true/false/nil,
    #   plan ID
    # ]
    # completed_days => nil=no job  true=day has been read  false=day not read yet
    @progress = @subscription.progress

    if @subscription.user.id != current_user.id
      redirect_to user_root_path
    end
  end

  # pause an active reading plan
  def pause
    subscription = Subscription.find(params[:subscription_id])
    subscription.active = false
    subscription.save!
    redirect_to subscription_path(subscription), notice: 'Reading plan paused.'
  end

  # resume a paused reading plan
  def resume
    subscription = Subscription.find(params[:subscription_id])
    subscription.active = true
    subscription.save!
    redirect_to subscription_path(subscription), notice: 'Reading plan resumed!'
  end
end
