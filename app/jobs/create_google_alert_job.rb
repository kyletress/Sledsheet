class CreateGoogleAlertJob < ApplicationJob
  queue_as :default

  def perform(athlete)
    manager = Galerts::Manager.new(ENV['GOOGLE_EMAIL'], ENV['GOOGLE_PASSWORD'])
    new_alert = manager.create("#{athlete.name} skeleton", {
      delivery: Galerts::RSS
    })
    athlete.update(rss_alert_url: new_alert.feed_url)
  end
end
