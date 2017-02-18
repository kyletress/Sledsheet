namespace :athletes do
  desc 'change athlete male boolean to gender enum'
  task set_gender: :environment do
    Athlete.all.each do |a|
      if a.male
        a.gender = 0
      else
        a.gender = 1
      end
      a.save
    end
  end

  desc "Heroku scheduler task to retrieve athlete articles"
  task scrape_articles: :environment do
    Athlete.all.each do |athlete|
      ScrapeAthleteArticlesFromGoogleJob.perform_later(athlete)
    end
  end
end
