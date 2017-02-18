class Article < ApplicationRecord
  belongs_to :athlete

  validates :title, uniqueness: { scope: :athlete_id }

  def self.from_google_alerts(entry, athlete)
    article = Article.new(
      title: entry.css('title').text,
      link: entry.css('link').attribute('href').value,
      description: entry.css('content').text,
      athlete: athlete
    )
    article
  end
end
