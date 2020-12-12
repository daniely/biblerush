class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:landing, :home, :subscribe]

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
end
