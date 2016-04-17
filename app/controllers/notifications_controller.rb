class NotificationsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def notify
    client = Twilio::REST::Client.new Rails.application.secrets.twilio_account_sid, Rails.application.secrets.twilio_auth_token
    message = client.messages.create from: '5183027581', to: '5185241467', body: 'Hello from sledsheet.com.'
    render plain: message.status
  end
end
