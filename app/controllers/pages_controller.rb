class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:landing, :home, :subscribe, :congratz, :message, :how_it_works, :about, :terms]

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

  def how_it_works
  end

  def about
  end

  def terms
  end

  def message
    @message = params[:m]
  end

  def subscribe
    email = params[:email]
    redirect_to "/users/sign_up?email=#{CGI.escape(email)}"
  end

  def welcome
  end

  def congratz
    @plan_job = PlanJob.find(params[:id])
    @next_plan_job = if params[:next_id].present?
                       PlanJob.find(params[:next_id])
                     else
                       PlanJob.none
                     end
  end
end
