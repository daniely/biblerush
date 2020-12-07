class PagesController < ApplicationController
  skip_before_action :authenticate_user!

  def landing
  end

  def home
  end
end
