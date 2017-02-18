desc "Heroku scheduler task to retrieve athlete articles"
task scrape_articles: :environment do
  Athlete.all.each do |athlete|
    ScrapeAthleteArticlesFromGoogleJob.perform_later(athlete)
  end
end
