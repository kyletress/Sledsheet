class Article < ApplicationRecord
  belongs_to :athlete

  def self.from_google_alerts(entry, athlete)
    article = Article.new(
      title: entry.css('title').inner_html,
      link: entry.css('link').inner_html,
      description: entry.css('content').inner_html,
      athlete: athlete
    )
    article
  end
end
