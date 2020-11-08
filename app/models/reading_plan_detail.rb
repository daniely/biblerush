class ReadingPlanDetail < ApplicationRecord
  belongs_to :reading_plan
  BIBLEGATEWAY_SEARCH_URL = 'https://www.biblegateway.com/passage/?search='

  # get link to url on biblegateway for reading plan passages
  def biblegateway_urls(version: 'WEB')
    [].tap do |response|
      detailed_reference.split(';').each do |ref|
        escaped_ref = URI.escape(ref)
        response << "#{BIBLEGATEWAY_SEARCH_URL}#{escaped_ref}&version=#{version}"
      end
    end
  end
end
