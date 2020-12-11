class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:landing, :home, :subscribe]

  def landing
    if user_signed_in?
      redirect_to progress_path
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

  def progress
    sid = params[:sid]
    if sid.present?
      @subscription = Subscription.find(params[:sid])
    else
      redirect_to reading_plans_path
    end
  end
end
