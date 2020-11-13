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
    url = "https://www.biblegateway.com/reading-plans/#{url_plan_name}/#{date.to_s.gsub('-','/')}?version=web"
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
      url = "https://www.biblegateway.com/reading-plans/#{url_plan_name}/#{date.to_s.gsub('-','/')}?version=web"
      puts url
      doc = Nokogiri::HTML(URI.open(url))
      cal = doc.at_css('table.calendar-table')
      cal.css('a.day').each_with_index do |day, i|
        url2 = "https://www.biblegateway.com#{day['href']}"
        doc2 = Nokogiri::HTML(URI.open(url2))
        reference = day['data-osis']
        detailed_reference = day['data-ref_display']
        day_num += 1
        puts [plan_name, reference, day_num].inspect
        # remove 'hidden' class on footnotes
        doc2.css('.rp-passage-text').each do |pass|
          next if pass.at_css('.footnotes').blank?
          pass.at_css('.footnotes')['class'] = 'footnotes'
        end
        passages = doc2.css('.rp-passage-text').map(&:to_html)
        ReadingPlanDetail.create!(
          reading_plan_id: plan.id,
          reference: reference,
          detailed_reference: detailed_reference,
          day: day_num,
          passages: passages
        )
      rescue => ex
        binding.pry
      end
      date = date.end_of_month + 1.day
    end while date.to_s != Date.parse('2021/01/01').to_s
  end
end
