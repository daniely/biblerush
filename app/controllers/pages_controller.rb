class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:landing, :home, :subscribe]

  def landing
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
