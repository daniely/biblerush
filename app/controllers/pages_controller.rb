class PagesController < ApplicationController
  skip_before_action :authenticate_user!

  def landing
  end

  def home
  end

  def subscribe
    email = params[:email]
    redirect_to "/users/sign_up?email=#{CGI.escape(email)}"
  end
end
