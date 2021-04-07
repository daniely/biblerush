class ReadingPlan < ApplicationRecord
  has_many :reading_plan_details

  PLAN_NAMES = %w[
    beginning
    chronological
    mcheyne
    old-new-testament
    historical
    bible-in-90-days
    gospels-in-40-days
    proverbs-monthly
  ].freeze

  def self.scrape_plan(url_plan_name)
    return unless PLAN_NAMES.include?(url_plan_name)

    date = Date.parse("2020/01/01")
    base_url = url = "https://www.biblegateway.com/"
    url = "#{url}reading-plans/#{url_plan_name}/#{date.to_s.gsub('-','/')}?version=web"
    plan_doc = Nokogiri::HTML(URI.open(url))
    plan_name = plan_doc.at_css('h1').text
    plan_desc = plan_doc.at_css('.day-plan-description').text
    duration = plan_doc.at_css('.day-num-days').text.split(' ')[1].to_i
    plan = ReadingPlan.where(plan_name: plan_name)
    return if plan.present?

    plan = ReadingPlan.create!(
      plan_name: plan_name,
      description: plan_desc,
      days: duration
    )
    day_num = 0
    begin
      puts url
      reference = plan_doc.css(".day[data-day_no='#{day_num}']").first['data-osis']
      detailed_reference = plan_doc.css(".day[data-day_no='#{day_num}']").first['data-ref_display']
      day_num += 1
      puts [plan_name, reference, day_num].inspect
      # remove 'hidden' class on footnotes
      plan_doc.css('.rp-passage-text').each do |pass|
        next if pass.at_css('.footnotes').blank?
        pass.at_css('.footnotes')['class'] = 'footnotes'
      end
      passages = plan_doc.css('.rp-passage-text').map(&:to_html)
      ReadingPlanDetail.create!(
        reading_plan_id: plan.id,
        reference: reference,
        detailed_reference: detailed_reference,
        day: day_num,
        passages: passages
      )
      url = "#{base_url}#{plan_doc.css('.next-link').first['href']}"
      plan_doc = Nokogiri::HTML(URI.open(url))
      break if plan_doc.css('[data-completed]').blank?
    #rescue => ex
      # when debugging
      #binding.pry
    end while true
  end
end
