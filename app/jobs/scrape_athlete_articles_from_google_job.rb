class ScrapeAthleteArticlesFromGoogleJob < ApplicationJob
  queue_as :default

  def perform(athlete)
    return unless athlete.rss_alert_url.present?
    doc = Nokogiri::XML(open(athlete.rss_alert_url))
    doc.css('entry').each do |entry|
      article = Article.from_google_alerts(entry, athlete)
      article.save
    end
  end
end
