class ReadingPlansController < ApplicationController
  def index
    @plans = ReadingPlan.all
  end
end
