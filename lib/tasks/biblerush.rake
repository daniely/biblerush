namespace :biblerush do
  task seed_plans: :environment do
    ReadingPlan::PLAN_NAMES.each do |url_plan_name|
      ReadingPlan.scrape_plan(url_plan_name)
    end
  end

  desc 'scrape WEB bible from biblegateway and fill out reading plan passages'
  task fill_passages: :environment do
    puts 'start fill passage details'

    ReadingPlanDetail.find_each do |plan|
      # reset the passages
      plan.passages = []
      plan.biblegateway_urls.each do |url|
        puts "parsing #{url}"
        doc = Nokogiri::HTML(URI.open(url))
        #version = doc.css('[data-translation]')[0].attributes['data-translation'].value
        #book = doc.css('.dropdown-display-text')[0].text.split(' ').first
        plan.passages << doc.at_css('.passage-content').to_html
      end
      plan.save!
    end

    #full_passage = doc.at_css('.passage-content').children[0].children.select{ |n| n.class == Nokogiri::XML::Element }
    #count_to_spacer = 0
    #full_passage.each do |section|
      #passage_group = section.children.select{ |n| n.class == Nokogiri::XML::Element }
      #if passage_group.first.children.text.downcase == 'footnotes'
        #next
      #end
      #count_to_spacer += passage_group.count
      #passage_group.each do |passage|
        #location_info = passage.attributes['class'].value.split(' ').last
        #short_book, chapter, verse = location_info.split('-')
        #passage = passage.text
        #format = nil
        #if verse == count_to_spacer.to_s
          ## add spacer
          #format = 'mb-4'
        #end

        #puts [short_book, chapter, verse, passage, format].inspect
      #end
    #end

    puts 'finished fill passage details'
  end
end
