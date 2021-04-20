namespace :biblerush do
  task seed_plans: :environment do
    ReadingPlan::PLAN_NAMES.each do |url_plan_name|
      ReadingPlan.scrape_plan(url_plan_name)
    end
  end

  task send_email_notifications: :environment do
    Rails.logger.tagged("PlanJob.send_email_notifications") do
      Rails.logger.info "sending all reading plan notification"
    end
    PlanJob.send_email_notifications
  end
end
