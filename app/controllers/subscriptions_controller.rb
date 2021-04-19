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
    # hash of [true/false, plan_job id]
    # e.g {1=>[true, "3c528950-e48c-44cb-affa-85bbb0474348"], 2=>[false, "d3ccb63d-0910-4192-8387-fc91bb18a76a"]}
    completed_days = {}.tap do |h|
      @subscription.plan_jobs.map{ |job| h[job.plan_day] = [job.read_at.present?, job.id] }
    end
    # [
    #   plan day,
    #   passage reference,
    #   true/false/nil,
    #   plan ID
    # ]
    # completed_days => nil=no job  true=day has been read  false=day not read yet
    @progress = @subscription.reading_plan.reading_plan_details.order(:day).map{ |a|
      [a.day, a.detailed_reference, completed_days[a.day].try(:[], 0), completed_days[a.day].try(:[], 1)]
    }

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
