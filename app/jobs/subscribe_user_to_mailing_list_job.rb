class SubscribeUserToMailingListJob < ActiveJob::Base
  queue_as :default

  def perform(user)
    gb = Gibbon::Request.new
    gb.lists.subscribe({id: ENV['MAILCHIMP_LIST_ID'], email: {email: user.email}, double_optin: false})
    gb.lists(ENV['MAILCHIMP_LIST_ID']).members.create(body: {email_address: user.email, status: "subscribed"}, double_optin: false)
  end
end
