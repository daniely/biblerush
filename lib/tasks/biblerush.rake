namespace :biblerush do
  task seed_plans: :environment do
    ReadingPlan::PLAN_NAMES.each do |url_plan_name|
      ReadingPlan.scrape_plan(url_plan_name)
    end
  end
end
