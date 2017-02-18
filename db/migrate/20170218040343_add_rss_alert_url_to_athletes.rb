class AddRssAlertUrlToAthletes < ActiveRecord::Migration[5.0]
  def change
    add_column :athletes, :rss_alert_url, :string
  end
end
